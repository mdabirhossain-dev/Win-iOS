//
//
//  String + Additions.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 28/9/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import Foundation

extension String {
    func convertToDate(_ format:String, utc:Bool)->Date!{
        let dateFormatter = DateFormatter()
        let local = Locale.init(identifier:"en_BD")
        dateFormatter.locale = local
        dateFormatter.dateFormat = format
        
        if utc {
            let zone = NSTimeZone(name: "UTC")! as TimeZone
            dateFormatter.timeZone = zone
        }
        
        return dateFormatter.date(from: self)
    }
    
    var isReallyEmpty: Bool {
        return self.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var formatToOneDecimalPlace: String {
        if let ratingDouble = Double(self) {
            let formattedRating = String(format: "%.1f", ratingDouble)
            return formattedRating
        } else {
            Log.info("Invalid number format")
        }
        return "0"
    }
}

extension String {
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self, options: Data.Base64DecodingOptions(rawValue: 0)) else {
            return nil
        }
        return String(data: data as Data, encoding: String.Encoding.utf8)
    }
    
    func toBase64() -> String? {
        guard let data = self.data(using: String.Encoding.utf8) else {
            return nil
        }
        return data.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
    }
}

extension Array {
    subscript(indexChecked index: Int) -> Element? {
        return (index < count) ? self[index] : nil
    }
}


extension String {
    /// Returns a new string where a leading "88" or "৮৮" is removed if present.
    /// Otherwise returns self unchanged.
    func dropLeading88() -> String {
        // Fast bail-out for very short strings
        guard count >= 2 else { return self }
        
        let firstTwo = prefix(2)
        
        if firstTwo == "88" || firstTwo == "৮৮" {
            return String(dropFirst(2))
        }
        
        return self
    }
}

// MARK: - REGEX


// MARK: - Shared helpers
public extension String {
    var trimmed: String { trimmingCharacters(in: .whitespacesAndNewlines) }
}

// MARK: - Email
public extension String {
    /// Pragmatic email validation for UX (not full RFC).
    /// Accepts: name.something+tag@domain.com
    var isValidEmail: Bool {
        let s = trimmed
        guard !s.isEmpty, s.count <= 254 else { return false }

        return s.range(
            of: #"^[A-Z0-9._%+\-]+@[A-Z0-9\-]+(\.[A-Z0-9\-]+)*\.[A-Z]{2,63}$"#,
            options: [.regularExpression, .caseInsensitive]
        ) != nil
    }
}

// MARK: - Bangladesh Mobile Number
public extension String {
    /// Bangladesh mobile: 01[3-9]XXXXXXXX (11 digits)
    /// Also accepts: 8801XXXXXXXXX, +8801XXXXXXXXX
    /// Allows user separators: spaces, dashes, parentheses.
    var isValidBDMobile: Bool {
        // keep digits and '+' only (strip spaces, dashes etc.)
        var s = trimmed.replacingOccurrences(of: #"[^\d+]"#, with: "", options: .regularExpression)

        // normalize optional +880 prefix => 880
        s = s.replacingOccurrences(of: #"^\+?88"#, with: "88", options: .regularExpression)

        // Match: (88)?01[3-9] + 8 digits
        return s.range(of: #"^(?:88)?01[3-9]\d{8}$"#, options: .regularExpression) != nil
    }

    /// Returns canonical E.164 format: +8801XXXXXXXXX (or nil if invalid)
    var bdMobileE164: String? {
        guard isValidBDMobile else { return nil }
        let digitsOnly = trimmed.replacingOccurrences(of: #"\D"#, with: "", options: .regularExpression)

        if digitsOnly.hasPrefix("8801") { return "+\(digitsOnly)" }
        if digitsOnly.hasPrefix("01") { return "+88\(digitsOnly)" }
        return nil
    }
}

//let email = (emailInput ?? "").trimmed
//guard !email.isEmpty else { view?.showError(message: "আপনার ইমেইল লিখুন"); return }
//guard email.isValidEmail else { view?.showError(message: "সঠিক ইমেইল দিন"); return }
//
//let phone = (phoneInput ?? "").trimmed
//guard !phone.isEmpty else { view?.showError(message: "আপনার মোবাইল নম্বর লিখুন"); return }
//guard phone.isValidBDMobile else { view?.showError(message: "সঠিক বাংলাদেশি মোবাইল নম্বর দিন (01XXXXXXXXX)"); return }
//
//let normalizedPhone = phone.bdMobileE164 // "+8801XXXXXXXXX"

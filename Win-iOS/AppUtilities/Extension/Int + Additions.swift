//
//
//  Int + Additions.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 8/12/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import Foundation

extension Int {
    func toBanglaNumberWithSuffix() -> String {
        let banglaDigits = ["০","১","২","৩","৪","৫","৬","৭","৮","৯"]
        let numberString = String(self)
        var banglaString = ""

        for char in numberString {
            if let digit = char.wholeNumberValue {
                banglaString.append(banglaDigits[digit])
            } else {
                banglaString.append(char) // keep non-digit chars unchanged
            }
        }

        return "\(banglaString)"
    }
}
extension String {
    func toBanglaNumberWithSuffix() -> String {
        let banglaDigits = ["০","১","২","৩","৪","৫","৬","৭","৮","৯"]
        let numberString = String(self)
        var banglaString = ""

        for char in numberString {
            if let digit = char.wholeNumberValue {
                banglaString.append(banglaDigits[digit])
            } else {
                banglaString.append(char) // keep non-digit chars unchanged
            }
        }

        return "\(banglaString)"
    }
}

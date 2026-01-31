//
//
//  WinServerError.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 12/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//


import Foundation

public enum WinServerError {
    public static let domain = "WinServerError"
}

/// Create ONE consistent server NSError.
/// - IMPORTANT: Any error created by this factory will be treated as “real server error” and shown as-is.
public enum WinServerErrorFactory {

    public static func make(
        status: Int,
        message: String?,
        error: String?,
        fallback: String = "সার্ভার ত্রুটি হয়েছে"
    ) -> NSError {
        let serverMsg = (error ?? message ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        let final = serverMsg.isEmpty ? "\(fallback) (\(status))" : serverMsg

        return NSError(
            domain: WinServerError.domain,
            code: status,
            userInfo: [NSLocalizedDescriptionKey: final]
        )
    }
}

public enum WinErrorMessageMapper {

    /// Rule:
    /// - If it’s a WinServerError => show as-is (real server message).
    /// - Otherwise => show meaningful Bangla.
    public static func message(for error: Error) -> String {

        let ns = error as NSError

        // ✅ Real server error: show as-is
        if ns.domain == WinServerError.domain {
            return ns.localizedDescription
        }

        // ✅ Your APIError mapping
        if let apiErr = error as? APIError {
            switch apiErr {
            case .transport(let e):
                return mapTransport(e)
            case .invalidResponse:
                return "সার্ভার থেকে সঠিক রেসপন্স পাওয়া যায়নি"
            case .emptyData:
                return "সার্ভার থেকে ডেটা পাওয়া যায়নি"
            case .decoding:
                return "ডেটা পড়তে সমস্যা হয়েছে"
            case .encoding:
                return "ডেটা পাঠাতে সমস্যা হয়েছে"
            case .badURL:
                return "ভুল রিকোয়েস্ট"
            case .server(let statusCode):
                // Ideally you won’t hit this if you create WinServerError from APIResponse
                return "সার্ভার ত্রুটি হয়েছে (\(statusCode))"
            }
        }

        // ✅ URLError fallback
        if let urlErr = error as? URLError {
            switch urlErr.code {
            case .notConnectedToInternet: return "ইন্টারনেট সংযোগ নেই"
            case .timedOut: return "সময় শেষ হয়ে গেছে, আবার চেষ্টা করুন"
            case .cannotFindHost, .cannotConnectToHost: return "সার্ভারে সংযোগ করা যাচ্ছে না"
            case .networkConnectionLost: return "নেটওয়ার্ক সংযোগ বিচ্ছিন্ন হয়েছে"
            default: return "নেটওয়ার্ক সমস্যা হয়েছে, আবার চেষ্টা করুন"
            }
        }

        // ✅ Generic fallback
        return "কিছু একটা সমস্যা হয়েছে, আবার চেষ্টা করুন"
    }

    private static func mapTransport(_ error: Error) -> String {
        let ns = error as NSError
        let code = URLError.Code(rawValue: ns.code)
        if ns.domain == NSURLErrorDomain {
            switch code {
            case .notConnectedToInternet: return "ইন্টারনেট সংযোগ নেই"
            case .timedOut: return "সময় শেষ হয়ে গেছে, আবার চেষ্টা করুন"
            case .cannotFindHost, .cannotConnectToHost: return "সার্ভারে সংযোগ করা যাচ্ছে না"
            case .networkConnectionLost: return "নেটওয়ার্ক সংযোগ বিচ্ছিন্ন হয়েছে"
            default: return "নেটওয়ার্ক সমস্যা হয়েছে, আবার চেষ্টা করুন"
            }
        }
        return "নেটওয়ার্ক সমস্যা হয়েছে, আবার চেষ্টা করুন"
    }
}

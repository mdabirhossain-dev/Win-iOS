//
//
//  UserFacingErrorMapper.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 12/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//



import Foundation

enum UserFacingErrorMapper {

    static func message(error: Error, serverMessage: String?) -> String {
        // ✅ If server gave us something meaningful, show it.
        if let serverMessage, !serverMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return serverMessage
        }

        // ✅ Network issues → Bangla
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet:
                return "ইন্টারনেট সংযোগ নেই। অনুগ্রহ করে আবার চেষ্টা করুন।"
            case .timedOut:
                return "সময় শেষ হয়ে গেছে। আবার চেষ্টা করুন।"
            default:
                return "নেটওয়ার্ক সমস্যা হয়েছে। আবার চেষ্টা করুন।"
            }
        }

        // ✅ Fallback
        return "কিছু একটা সমস্যা হয়েছে। অনুগ্রহ করে আবার চেষ্টা করুন।"
    }
}
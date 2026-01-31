//
//
//  OtpVerificationEntity.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 14/10/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//



import Foundation

// MARK: - Entity
struct OtpVerificationRequest: Encodable {
    let msisdn: String
    let password: String // It should be "otpCode", but unfortunately the parameter name is password for OTP verification.
}

struct ResetPasswordRequest: Encodable {
    let msisdn: String
    let password: String
    let otp: String
}

struct ResendOtpRequest {
    let msisdn: String
    let otpEvent: OtpEvent
}

struct AlertMessage: Decodable {
    let success: Bool
    let message: String
}


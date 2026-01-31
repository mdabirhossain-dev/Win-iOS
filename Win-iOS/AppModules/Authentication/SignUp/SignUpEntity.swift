//
//
//  SignUpEntity.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 15/10/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import Foundation

struct SignUpUserInfo: Encodable {
    let msisdn: String
    let password: String?
    let invitationCode: String?
}

struct SignUpRequest: Encodable {
    let msisdn: String
    let password: String
    let fullName: String
    let dateOfBirth: String
    let gender: String
    let otp: String
    let invitationCode: String

    enum CodingKeys: String, CodingKey {
        case msisdn = "Msisdn"
        case password = "Password"
        case fullName = "FullName"
        case dateOfBirth = "DateOfBirth"
        case gender = "Gender"
        case otp = "Otp"
        case invitationCode = "InvitationCode"
    }
}

struct SignUpResponse: Decodable {
    let message: String?
    let isAuthenticated: Bool?
    let msisdn: String?
    let roles: String?
    let token: String?
    let earnedPoints, signupPoints, invitationPoints: Int?
    let signupImage: String?
    let appSigninImage: String?
    let appSigninPoints: Int?
}

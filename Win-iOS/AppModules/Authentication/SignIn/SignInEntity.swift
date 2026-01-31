//
//
//  SignInEntity.swift
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
struct SignInRequest: Encodable {
    let msisdn: String
    let password: String
}

struct SignInResponse: Decodable {
    let message: String?
    let isAuthenticated: Bool?
    let msisdn: String?
    let token: String?
    let earnedPoints, signupPoints, invitationPoints: Int?
    let signupImage, appSigninImage: String?
    let appSigninPoints: Int?
}

//
//
//  UpdateProfileEntity.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 12/11/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import Foundation

struct UpdateProfileRequest: Encodable {
    let fullName: String
    let gender: String
    let userAvatarId: String
    
    enum CodingKeys: String, CodingKey {
        case fullName = "FullName"
        case gender = "Gender"
        case userAvatarId = "UserAvatarId"
    }
}

struct UserAvatar: Decodable {
    let userAvatarId: Int?
    let requiredLevel: Int?
    let avatarImage: String?
    let imageSource: String?
    let islocked: Bool?
}
typealias UserAvatarList = [UserAvatar]

struct UpdateProfileScreenViewModel: Equatable {
    let msisdnText: String
    let userNameText: String
    let avatarURL: String?
}

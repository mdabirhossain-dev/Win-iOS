//
//
//  RedeemScoreEntity.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 6/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//


import Foundation

struct RedeemScore: Decodable {
    let totalScore: Int?
    let giftVouchers: [Cashback]?
    let cashback: [Cashback]?
    let termsAndConditions: String?
    let campaignGifts: JSONAny?
    let isSocial: Bool?
}

struct Cashback: Decodable {
    let couponTypeID, couponValue: Int?
    let title: String?
    let couponImage: String?
    let isActive: Bool?
    let pointsNeeded: Int?
    let useURL: JSONAny?
    let redemptionGiftTypeID: Int?
    let startDate, endDate: String?
    let maxNumberOfAttempts: Int?

    enum CodingKeys: String, CodingKey {
        case couponTypeID = "couponTypeId"
        case couponValue, title, couponImage, isActive, pointsNeeded
        case useURL = "useUrl"
        case redemptionGiftTypeID = "redemptionGiftTypeId"
        case startDate, endDate, maxNumberOfAttempts
    }
}

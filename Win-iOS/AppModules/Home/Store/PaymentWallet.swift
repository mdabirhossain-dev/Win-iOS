//
//
//  PaymentWallet.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 20/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//


import Foundation

struct PaymentWallet: Codable {
    let walletID: Int?
    let walletTitle: String?
    let clientID: Int?
    let isActive: Bool?
    let walletImage: String?
    let walletType: Int?

    enum CodingKeys: String, CodingKey {
        case walletID = "walletId"
        case walletTitle
        case clientID = "clientId"
        case isActive, walletImage, walletType
    }
}
typealias PaymentWallets = [PaymentWallet]

struct PurchasePlansData: Decodable {
    let activeSubscription: JSONAny?
    let subscriptionPlans, ondemandPlans: [PurchasePlan]?
    let bkashSubscriptionPlans, bkashOndemandPlans: [JSONAny]?
}

struct PurchasePlan: Decodable {
    let planID: Int?
    let title: String?
    let planDescription: String?
    let price: Int?
    let priceString: String?
    let durationInDays, points: Int?
    let isActive: Bool?
    let bonusPercentage: Int?

    enum CodingKeys: String, CodingKey {
        case planID = "planId"
        case title, planDescription, price
        case priceString = "price_String"
        case durationInDays, points, isActive, bonusPercentage
    }
}

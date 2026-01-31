//
//
//  SubscriptionHistoryEntity.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 21/10/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import Foundation

typealias SubscriptionHistoryResponse = [SubscriptionHistory]

struct SubscriptionHistory: Decodable {
    let serviceID, onDate: String?
    let points: Int?
    let actionType: ActionType?
    let priceInTaka: Double?
    let durationInDays: Int?
    
    // Custom initializer to handle the decoding of actionType correctly
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        serviceID = try container.decodeIfPresent(String.self, forKey: .serviceID)
        onDate = try container.decodeIfPresent(String.self, forKey: .onDate)
        points = try container.decodeIfPresent(Int.self, forKey: .points)
        priceInTaka = try container.decodeIfPresent(Double.self, forKey: .priceInTaka)
        durationInDays = try container.decodeIfPresent(Int.self, forKey: .durationInDays)
        
        // Decode actionType as ActionType enum
        let actionTypeRawValue = try container.decodeIfPresent(Int.self, forKey: .actionType)
        actionType = actionTypeRawValue.flatMap { ActionType(rawValue: $0) }
    }
    
    private enum CodingKeys: String, CodingKey {
        case serviceID, onDate, points, actionType, priceInTaka, durationInDays
    }
}

enum ActionType: Int, Decodable {
    case paymentSuccess = 1
    case receivedAsGift = 3
    case sendAsGift = 4
    
    var description: String {
        switch self {
        case .paymentSuccess:
            return "পেমেন্ট সফল"
        case .receivedAsGift:
            return "গিফট পেয়েছেন"
        case .sendAsGift:
            return "গিফট করেছেন"
        }
    }
}

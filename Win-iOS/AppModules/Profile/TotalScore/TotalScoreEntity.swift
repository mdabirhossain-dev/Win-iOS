//
//
//  TotalScoreEntity.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 18/11/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import Foundation

struct CampaignWiseScore: Decodable {
    let campaignId: Int?
    let campaignTitle: String?
    let score: Int?
}

typealias CampaignWiseScores = [CampaignWiseScore]

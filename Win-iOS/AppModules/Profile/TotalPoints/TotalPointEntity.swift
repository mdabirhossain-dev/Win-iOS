//
//
//  TotalPointEntity.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 18/11/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import Foundation

struct TotalPointResponse: Decodable {
    let totalPoints: Int?
    let pointsBreakdown: [PointBreakdown]?
}

struct PointBreakdown: Decodable {
    let score: Int?
    let walletId: Int?
    let walletTitle: String?
    let clientId: Int?
}

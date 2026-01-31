//
//
//  PointTransferRequest.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 1/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//


import Foundation

struct PointTransferRequest: Encodable {
    let receiverMSISDN: String
    let walletID: Int
    let pointAmount: Int
    
    enum CodingKeys: String, CodingKey {
        case receiverMSISDN = "ReceiverMsisdn"
        case walletID = "WalletId"
        case pointAmount = "PointAmount"
    }
}

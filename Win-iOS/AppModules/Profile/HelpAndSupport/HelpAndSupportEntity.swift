//
//
//  HelpAndSupportEntity.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 12/11/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import Foundation

struct HelpAndSupportRequest: Encodable {
    let name: String
    let message: String
    let msisdn: String
    let email: String

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case message = "Message"
        case msisdn
        case email = "Email"
    }
}

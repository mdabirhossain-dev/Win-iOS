//
//
//  InvitationResponse.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 29/12/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//

import Foundation

struct InvitationResponse: Decodable {
    let invitationMappingID: Int?
    let msisdn, invitationCode, codeGenerationDate: String?
    let invitedBy, joinDate, joinDateBengali: String?
    let point: Int?

    enum CodingKeys: String, CodingKey {
        case invitationMappingID = "invitationMappingId"
        case msisdn, invitationCode, codeGenerationDate, invitedBy, joinDate, joinDateBengali, point
    }
}

typealias InvitationList = [InvitationResponse]

//
//
//  ScoreboardEntity.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 21/10/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import Foundation

struct Campaign: Decodable {
    let campaignID: Int?
    let title, startDate, endDate: String?
    let numberOfQuestions, quizPlayDurationInSeconds: Int?
    let campaignImage: String?

    let patchID: Int?
    let clientID: Int?
    let bengaliDuration: String?
    let quizType: Int?
    let questionTypes: Int?
    let maxNumberOfDailyAttempts: Int?

    let isActive: Bool?
    let isAvailableForPlay: Bool?

    let isMsisdnSpecific: Bool?
    let msisdnSpecificType, leaderboardItems: Int?

    let isSelectiveQuestions: Bool?
    let claimText: JSONAny?
    let termsText: String?
    let isCumulative: Bool?

    let clientName: JSONAny?
    let isAttemptsCumulative: Bool?
    let dMinusOneLeaderboard: Bool?

    let participationPoint, bonusPoint: Int?

    let questionModalities: [QuestionModality]?

    let leaderboardItemsList: [LeaderboardItem]?
        
    let redemptionLeaderboard, dMinusOneLeaderboardItems, campaignGifts, ludoScoreBoard: JSONAny?

    enum CodingKeys: String, CodingKey {
        case campaignID = "campaignId"
        case title, startDate, endDate
        case numberOfQuestions, quizPlayDurationInSeconds, campaignImage
        case patchID = "patchId"
        case clientID = "clientId"
        case bengaliDuration, quizType, questionTypes, maxNumberOfDailyAttempts
        case isActive, isAvailableForPlay
        case isMsisdnSpecific, msisdnSpecificType, leaderboardItems
        case isSelectiveQuestions, claimText, termsText, isCumulative
        case clientName, isAttemptsCumulative, dMinusOneLeaderboard
        case participationPoint, bonusPoint
        case questionModalities
        case leaderboardItemsList, dMinusOneLeaderboardItems, campaignGifts, ludoScoreBoard
        case redemptionLeaderboard
    }
}
typealias CampaignList = [Campaign]

// MARK: - ScoreboardCampaign
struct ScoreboardCampaign: Decodable {
    let campaignID: Int?
    let title, startDate, endDate: String?
    let numberOfQuestions, quizPlayDurationInSeconds: Int?
    let campaignImage: String?
    let patchID, clientID: Int?
    let bengaliDuration: String?
    let quizType, maxNumberOfDailyAttempts: Int?
    let isMsisdnSpecific: Bool?
    let msisdnSpecificType, leaderboardItems: Int?
    let isAvailableForPlay: Bool?
    let participationPoint, bonusPoint: Int?
    let questionModalities: [JSONAny]?
    let leaderboardItemsList: [LeaderboardItem]?
    let dMinusOneLeaderboardItems: JSONAny?
    let campaignGifts: [JSONAny]?
    let ludoScoreBoard: JSONAny?
    let redemptionLeaderboard: RedemptionLeaderboard?
    
    enum CodingKeys: String, CodingKey {
        case campaignID = "campaignId"
        case title, startDate, endDate, numberOfQuestions, quizPlayDurationInSeconds, campaignImage
        case patchID = "patchId"
        case clientID = "clientId"
        case bengaliDuration, quizType, maxNumberOfDailyAttempts, isMsisdnSpecific, msisdnSpecificType, leaderboardItems, isAvailableForPlay, participationPoint, bonusPoint, questionModalities, leaderboardItemsList, dMinusOneLeaderboardItems, campaignGifts, ludoScoreBoard, redemptionLeaderboard
    }
}
typealias ScoreboardCampaignList = [ScoreboardCampaign]

// MARK: - LeaderboardItemsList
struct LeaderboardItem: Decodable {
    let uniqueID: Int?
    let fullName, msisdn: String?
    let score, timeInMilliseconds, userRank, totalRedeemAmount: Int?
    let userAvatar: String?
    let isMyself: Bool?

    enum CodingKeys: String, CodingKey {
        case uniqueID = "uniqueId"
        case fullName, msisdn, score, timeInMilliseconds, userRank, totalRedeemAmount, userAvatar, isMyself
    }
}

enum JSONAny: Decodable {
    case string(String)
    case number(Double)
    case bool(Bool)
    case object([String: JSONAny])
    case array([JSONAny])
    case null

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            self = .null
        } else if let b = try? container.decode(Bool.self) {
            self = .bool(b)
        } else if let i = try? container.decode(Int.self) {
            self = .number(Double(i))
        } else if let d = try? container.decode(Double.self) {
            self = .number(d)
        } else if let s = try? container.decode(String.self) {
            self = .string(s)
        } else if let arr = try? container.decode([JSONAny].self) {
            self = .array(arr)
        } else if let dict = try? container.decode([String: JSONAny].self) {
            self = .object(dict)
        } else {
            throw DecodingError.typeMismatch(JSONAny.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unsupported JSON value"))
        }
    }
}

extension JSONAny {
    var stringValue: String? {
        if case let .string(s) = self { return s }
        return nil
    }
    var intValue: Int? {
        if case let .number(n) = self { return Int(n) }
        return nil
    }
    var boolValue: Bool? {
        if case let .bool(b) = self { return b }
        return nil
    }
    var arrayValue: [JSONAny]? {
        if case let .array(a) = self { return a }
        return nil
    }
    var objectValue: [String: JSONAny]? {
        if case let .object(o) = self { return o }
        return nil
    }
    var isNull: Bool {
        if case .null = self { return true }
        return false
    }
}

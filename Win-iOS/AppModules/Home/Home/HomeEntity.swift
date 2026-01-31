//
//
//  HomeContents.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 13/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//

import Foundation


// MARK: - HomeContents
struct HomeContents: Decodable {
    let quizCategories: [QuizCategory]?
    let campaigns: [Campaign]?
    let features: [DailyCheckIn]?
    let happyHours: [HappyHour]?
    let predictAndWin, spellingMaster: [JSONAny]?
    let banners: [Banner]?
    let multiPartCampaignBanners, dailyLeaderboardItems: [JSONAny]?
    let lakhopotiLeaderboard, redemptionLeaderboard: [RedemptionLeaderboard]?
    let flashNotifications, campaignDetails: [JSONAny]?
    let onlineGames: [OnlineGame]?
    let watchAndWin: [WatchAndWin]?
    let noCampaignItems: JSONAny?
    let pointTransferDetails: [PointTransferDetail]?
    let billboards: [Billboard]?
    let campaignsWithLeaderboards: [JSONAny]?
    let lakhpotiLeaderBoard: [LakhpotiLeaderBoard]?
    let dailyCheckIn: [DailyCheckIn]?
    let redemptionCouponTypes: [RedemptionCouponType]?
    let userJourneyProgress: [UserJourneyProgress]?
    let lakhopotis: [Lakhopoti]?
    let ludoData: [LudoData]?
    let ticTacToeData: [TicTacToeData]?
}

// MARK: - Banner
struct Banner: Decodable {
    let bannerID: Int?
    let bannerTitle, subTitle: String?
    let bannerImage: String?
    let campaignID: Int?
    let createdDate, modifiedDate: String?
    let isActive: Bool?
    let routePath, campaignEndDate: String?

    enum CodingKeys: String, CodingKey {
        case bannerID = "bannerId"
        case bannerTitle, subTitle, bannerImage
        case campaignID = "campaignId"
        case createdDate, modifiedDate, isActive, routePath, campaignEndDate
    }
}

// MARK: - Billboard
struct Billboard: Decodable {
    let orderID, campaignID, lakhopotiID, noCampaignID: Int?
    let title, subTitle, startDate, endDate: String?
    let registrationEndDate: JSONAny?
    let currentTime: String?
    let campaignImage: String?
    let lakhopotiImage: JSONAny?
    let image: String?
    let bengaliDuration: String?
    let isActive: Bool?
    let clientID, billboardType: Int?
    let termsText: String?
    let featureID: Int?
    let playURL: String?

    enum CodingKeys: String, CodingKey {
        case orderID = "orderId"
        case campaignID = "campaignId"
        case lakhopotiID = "lakhopotiId"
        case noCampaignID = "noCampaignId"
        case title, subTitle, startDate, endDate, registrationEndDate, currentTime, campaignImage, lakhopotiImage, image, bengaliDuration, isActive
        case clientID = "clientId"
        case billboardType, termsText
        case featureID = "featureId"
        case playURL = "playUrl"
    }
}

// MARK: - QuestionModality
struct QuestionModality: Decodable {
    let id, campaignID, questionGroupID, numberOfQuestions: Int?
    let quizPlayDurationInSeconds, maxNumberOfDailyAttempts, participationPoint, bonusPoint: Int?
    let wbIsActive: Bool?
    let wbIconImage, wbPopupImage: JSONAny?
    let wbParticipationPoint, wbBonusPoint, wbMaxNumberOfDailyAttempts, wbCorrectStreakNeeded: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case campaignID = "campaignId"
        case questionGroupID = "questionGroupId"
        case numberOfQuestions, quizPlayDurationInSeconds, maxNumberOfDailyAttempts, participationPoint, bonusPoint, wbIsActive, wbIconImage, wbPopupImage, wbParticipationPoint, wbBonusPoint, wbMaxNumberOfDailyAttempts, wbCorrectStreakNeeded
    }
}

// MARK: - DailyCheckIn
struct DailyCheckIn: Decodable {
    let featureID: Int?
    let featureTitle: String?
    let numberOfQuestions, quizPlayDurationInSeconds, questionType: Int?
    let featureImage: String?
    let isActive: Bool?
    let maxNumberOfFreeAttempts, maxNumberOfPremiumAttempts: Int?
    let limitApplicableDaily: Bool?
    let participationPoint, bonusPoint: Int?
    let termsText: String?
    let isSelectiveQuestions, wbIsActive: Bool?
    let wbIconImage, wbPopupImage: JSONAny?
    let wbParticipationPoint, wbBonusPoint, wbMaxNumberOfDailyAttempts, wbCorrectStreakNeeded: Int?
    let playURL: JSONAny?
    let mpParticipationPoint, mpBonusScore, mpNumberOfQuestions: Int?

    enum CodingKeys: String, CodingKey {
        case featureID = "featureId"
        case featureTitle, numberOfQuestions, quizPlayDurationInSeconds, questionType, featureImage, isActive, maxNumberOfFreeAttempts, maxNumberOfPremiumAttempts, limitApplicableDaily, participationPoint, bonusPoint, termsText, isSelectiveQuestions, wbIsActive, wbIconImage, wbPopupImage, wbParticipationPoint, wbBonusPoint, wbMaxNumberOfDailyAttempts, wbCorrectStreakNeeded
        case playURL = "playUrl"
        case mpParticipationPoint, mpBonusScore, mpNumberOfQuestions
    }
}

// MARK: - HappyHour
struct HappyHour: Decodable {
    let happyHourID: Int?
    let title, startDate, endDate: String?
    let campaignID: JSONAny?
    let numberOfQuestions, quizPlayDurationInSeconds: Int?
    let happyHourImage: String?
    let questionTypes: Int?
    let bengaliDuration: String?
    let numberOfAttempts: Int?
    let isActive, isSelectiveQuestions: Bool?
    let termsText: String?
    let clientID: Int?
    let clientName: JSONAny?
    let participationPoint, bonusPoint: Int?

    enum CodingKeys: String, CodingKey {
        case happyHourID = "happyHourId"
        case title, startDate, endDate
        case campaignID = "campaignId"
        case numberOfQuestions, quizPlayDurationInSeconds, happyHourImage, questionTypes, bengaliDuration, numberOfAttempts, isActive, isSelectiveQuestions, termsText
        case clientID = "clientId"
        case clientName, participationPoint, bonusPoint
    }
}

// MARK: - LakhopotiLeaderboard
struct RedemptionLeaderboard: Decodable {
    let totalRedeemAmount, redemptionCount: Int?
    let redemptionLeaderboardItems: [RedemptionLeaderboardItem]?
}

// MARK: - RedemptionLeaderboardItem
struct RedemptionLeaderboardItem: Decodable {
    let fullName, msisdn: String?
    let redeemAmount, userRank: Int?
    let userAvatar: String?
    let lakhopotiID: Int?

    enum CodingKeys: String, CodingKey {
        case fullName, msisdn, redeemAmount, userRank, userAvatar
        case lakhopotiID = "lakhopotiId"
    }
}

// MARK: - Lakhopoti
struct Lakhopoti: Decodable {
    let lakhopotiID: Int?
    let title, currentTime, startDate, endDate: String?
    let registrationStartDate, registrationEndDate: String?
    let numberOfQuestions, quizPlayDurationInSeconds: Int?
    let lakhopotiImage: String?
    let bengaliDuration: JSONAny?
    let isActive: Bool?
    let claimText: JSONAny?
    let termsText: String?
    let participationPoint: Int?
    let milestones: [Milestone]?
    let userDetail: JSONAny?
    let milestoneBreakDurationInSeconds, finalQuestionPlayDurationInSeconds, quizBreakDurationInSeconds, totalRegistrationCount: Int?
    let lakhopotiLeaderboard, lakhpotiLeaderBoard, inviteCount, bonusPointPerInvite: JSONAny?
    let bonusPointPerInviteReciever: JSONAny?
    let bonusQuestionPoint, bonusQuestionTime: Int?

    enum CodingKeys: String, CodingKey {
        case lakhopotiID = "lakhopotiId"
        case title, currentTime, startDate, endDate, registrationStartDate, registrationEndDate, numberOfQuestions, quizPlayDurationInSeconds, lakhopotiImage, bengaliDuration, isActive, claimText, termsText, participationPoint, milestones, userDetail, milestoneBreakDurationInSeconds, finalQuestionPlayDurationInSeconds, quizBreakDurationInSeconds, totalRegistrationCount, lakhopotiLeaderboard, lakhpotiLeaderBoard, inviteCount, bonusPointPerInvite, bonusPointPerInviteReciever, bonusQuestionPoint, bonusQuestionTime
    }
}

// MARK: - Milestone
struct Milestone: Decodable {
    let milestoneID, lakhopotiID, milestoneNumber: Int?
    let title: String?
    let amountInTaka: Int?
    let amountBengali: String?
    let milestoneImage: JSONAny?
    let description: String?
    let numberOfQuestionsNeededToReach: Int?
    let isActive, isCurrentMilestone: Bool?

    enum CodingKeys: String, CodingKey {
        case milestoneID = "milestoneId"
        case lakhopotiID = "lakhopotiId"
        case milestoneNumber, title, amountInTaka, amountBengali, milestoneImage, description, numberOfQuestionsNeededToReach, isActive, isCurrentMilestone
    }
}

// MARK: - LakhpotiLeaderBoard
struct LakhpotiLeaderBoard: Decodable {
    let lakhpotiID: Int?
    let title, startDate: String?
    let campaignImage: String?
    let leaderboardItem: RedemptionLeaderboard?

    enum CodingKeys: String, CodingKey {
        case lakhpotiID = "lakhpotiId"
        case title, startDate, campaignImage, leaderboardItem
    }
}

// MARK: - LudoData
struct LudoData: Decodable {
    let ludoID: Int?
    let featureTitle: String?
    let ludoImageIcon: String?
    let termsText: String?
    let playURL: String?
    let ludoBackgroundImage: String?
    let participationPoint: Int?

    enum CodingKeys: String, CodingKey {
        case ludoID = "ludoId"
        case featureTitle, ludoImageIcon, termsText
        case playURL = "playUrl"
        case ludoBackgroundImage, participationPoint
    }
}

// MARK: - OnlineGame
struct OnlineGame: Decodable {
    let onlineGameID: Int?
    let title: String?
    let gameImage: String?
    let gameIcon: String?
    let isActive: Bool?

    enum CodingKeys: String, CodingKey {
        case onlineGameID = "onlineGameId"
        case title, gameImage, gameIcon, isActive
    }
}

// MARK: - PointTransferDetail
struct PointTransferDetail: Decodable {
    let id: Int?
    let title: String?
    let image: String?
    let buttonTitle: String?
}

// MARK: - QuizCategory
struct QuizCategory: Decodable {
    let quizCategoryID: Int?
    let title: String?
    let displayOrder: Int?
    let isActive: Bool?
    let createdDate, modifiedDate: String?
    let imageSource: String?
    let numberOfQuestions, quizPlayDurationInSeconds, maxNumberOfFreeAttempts, maxNumberOfPremiumAttempts: Int?
    let participationPoint, bonusPoint: Int?
    let parentID: JSONAny?
    let termsText: String?
    let wbIsActive: Bool?
    let wbIconImage, wbPopupImage: String?
    let wbParticipationPoint, wbBonusPoint, wbMaxNumberOfDailyAttempts, wbCorrectStreakNeeded: Int?
    let mpParticipationPoint, mpBonusScore, mpNumberOfQuestions: Int?

    enum CodingKeys: String, CodingKey {
        case quizCategoryID = "quizCategoryId"
        case title, displayOrder, isActive, createdDate, modifiedDate, imageSource, numberOfQuestions, quizPlayDurationInSeconds, maxNumberOfFreeAttempts, maxNumberOfPremiumAttempts, participationPoint, bonusPoint
        case parentID = "parentId"
        case termsText, wbIsActive, wbIconImage, wbPopupImage, wbParticipationPoint, wbBonusPoint, wbMaxNumberOfDailyAttempts, wbCorrectStreakNeeded, mpParticipationPoint, mpBonusScore, mpNumberOfQuestions
    }
}

// MARK: - RedemptionCouponType
struct RedemptionCouponType: Decodable {
    let totalScore: Int?
    let giftVouchers, cashback, termsAndConditions, campaignGifts: JSONAny?
    let isSocial: Bool?
}

// MARK: - TicTacToeData
struct TicTacToeData: Decodable {
    let id, featureID: Int?
    let featureTitle: String?
    let featureImage: String?
    let quizPlayDurationInSeconds, participationPoint, bonusPoint, numberOfGame: Int?
    let termsText: String?
    let backgroundImage: String?
    let probability: Int?
    let featureBackgroundImage: String?
    let displayOrder: JSONAny?

    enum CodingKeys: String, CodingKey {
        case id
        case featureID = "featureId"
        case featureTitle, featureImage, quizPlayDurationInSeconds, participationPoint, bonusPoint, numberOfGame, termsText, backgroundImage, probability, featureBackgroundImage, displayOrder
    }
}

// MARK: - UserJourneyProgress
struct UserJourneyProgress: Decodable {
    let msisdn: String?
    let earnedPoints: Int?
    let signUp, profileUpdate, premiumSubscription, invite: Invite?
    let appSignin: JSONAny?
}

// MARK: - Invite
struct Invite: Decodable {
    let pointsEarningEventID: Int?
    let eventDetails, eventDetailsBangla: String?
    let point: Int?
    let isActive: Bool?
    let eventImage, eventIcon: String?
    let isCompleted: Bool?

    enum CodingKeys: String, CodingKey {
        case pointsEarningEventID = "pointsEarningEventId"
        case eventDetails, eventDetailsBangla, point, isActive, eventImage, eventIcon, isCompleted
    }
}

// MARK: - WatchAndWin
struct WatchAndWin: Decodable {
    let title: String?
    let imageSource: String?
    let termsAndConditions: String?
    let participationPoint, bonusPoint: Int?
}

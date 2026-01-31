//
//
//  ProfileEntity.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 18/11/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

// MARK: - API Model
struct UserSummaryResponse: Decodable {
    let msisdn: String?
    let fullName: String?
    let dateOfBirth: String?
    let gender: String?
    let userRank: Int?
    let userLevel: Int?
    let totalScore: Int?
    let scoreBreakdown: [PointBreakdown]?
    let campaignWiseScores: [CampaignWiseScore]?
    let playTimeInMilliseconds: Int?
    let userAvatarId: Int?
    let avatarImage: String?
    let userJourneyProgress: UserJourneyProgress?
    let genericTermsAndConditions: String?
    let lakhopotiRedeemDetails: LakhopotiRedeemDetails?
    let userPoint: Int?
    let userScore: Int?

    struct UserJourneyProgress: Decodable {
        let pointsEarningJourneyId: Int?
        let msisdn: String?
        let signUp: Bool?
        let signUpWithInvitation: Bool?
        let profileUpdate: Bool?
        let premiumSubscription: Bool?
        let invite: Bool?
        let appSignin: Bool?
    }

    struct LakhopotiRedeemDetails: Decodable { }
}

// MARK: - Journey VM (3 fixed steps)
struct ProfileJourneyViewModel {
    struct Step { let isCompleted: Bool }
    let steps: [Step]

    static var empty: ProfileJourneyViewModel {
        .init(steps: [
            .init(isCompleted: false),
            .init(isCompleted: false),
            .init(isCompleted: false)
        ])
    }
}

extension UserSummaryResponse.UserJourneyProgress {
    func toJourneyViewModel() -> ProfileJourneyViewModel {
        .init(steps: [
            .init(isCompleted: signUp ?? false),
            .init(isCompleted: profileUpdate ?? false),
            .init(isCompleted: invite ?? false)
        ])
    }
}

// MARK: - Social
enum SocialLinkType {
    case telegram
    case facebook

    var appURL: URL? {
        switch self {
        case .telegram:
            return URL(string: "tg://resolve?domain=Win_Quiz")
        case .facebook:
            return nil
        }
    }

    var webURL: URL {
        switch self {
        case .telegram:
            return URL(string: "https://t.me/Win_Quiz")!
        case .facebook:
            return URL(string: "https://www.facebook.com/61555393525585")!
        }
    }
}

// MARK: - UI Models
struct SocialInfoModel {
    let animation: LottieFiles
    let title: String
    let description: String
}

// MARK: - Screen Sections/Items
enum ProfileSection {
    case userInfo
    case points
    case lakhpoti
    case campaignScores
    case journey
    case option(ProfileOption)
    case social(ProfileSocial)
    case signOut
}

enum ProfileOption: CaseIterable {
    case redeemScore
    case requestPoint
    case giftPoint
    case pointHistory
    case helpAndSupport
    case rate
    case invite
    case rulesAndRegulations
    case privacyPolicy

    var title: String {
        switch self {
        case .redeemScore: return "স্কোর রিডিম করুন"
        case .requestPoint: return "রিকোয়েস্ট পয়েন্ট"
        case .giftPoint: return "গিফট পয়েন্ট"
        case .pointHistory: return "পয়েন্ট হিস্ট্রি"
        case .helpAndSupport: return "হেল্প অ্যান্ড সাপোর্ট"
        case .rate: return "রেট করুন"
        case .invite: return "ইনভাইট"
        case .rulesAndRegulations: return "নিয়ম ও শর্তাবলী"
        case .privacyPolicy: return "প্রাইভেসি পলিসি"
        }
    }

    var iconName: String {
        switch self {
        case .redeemScore: return "starCircle"
        case .requestPoint: return "history"
        case .giftPoint: return "giftbox"
        case .pointHistory: return "history"
        case .helpAndSupport: return "headphone"
        case .rate: return "star"
        case .invite: return "userGroup"
        case .rulesAndRegulations: return "infoCircle"
        case .privacyPolicy: return "caution"
        }
    }
}

enum ProfileSocial: CaseIterable {
    case telegram
    case facebook

    var animation: LottieFiles {
        switch self {
        case .telegram: return .telegram
        case .facebook: return .facebook
        }
    }

    var title: String {
        switch self {
        case .telegram: return "Win টেলিগ্রাম চ্যানেল"
        case .facebook: return "Win ফেসবুক পেজ"
        }
    }

    var description: String {
        switch self {
        case .telegram: return "আপডেট পেতে জয়েন করুন"
        case .facebook: return "আপডেট পেতে লাইক করুন"
        }
    }

    var linkType: SocialLinkType {
        switch self {
        case .telegram: return .telegram
        case .facebook: return .facebook
        }
    }
}

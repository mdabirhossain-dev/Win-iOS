//
//
//  ProfileInterface.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 7/10/25.
//  Contact me if anything is needed:
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

enum ProfileInterface: CaseIterable {
    case userInfo, totalPoint, totalScore, lakhpoti, campaign, userJourneyProgress, redeemScore, requestPoint, giftPoint, pointHistory, helpAndSupport, rate, invite, rulesAndRegulations, privacyPolicy, joinTelegram(animation: LottieFiles), likeFacebook(animation: LottieFiles), signOut
    
    // Manually implementing the `allCases` property for CaseIterable conformance
    static var allCases: [ProfileInterface] {
        return [
            .userInfo, .totalPoint, .totalScore, .lakhpoti, .campaign, .userJourneyProgress, .redeemScore,
            .requestPoint, .giftPoint, .pointHistory, .helpAndSupport, .rate, .invite,
            .rulesAndRegulations, .privacyPolicy, .joinTelegram(animation: LottieFiles.telegram), .likeFacebook(animation: LottieFiles.facebook), .signOut
        ]
    }
    
    var icon: Any {
        switch self {
        case .redeemScore:
            return "starCircle"
        case .requestPoint:
            return "history"
        case .giftPoint:
            return "giftbox"
        case .pointHistory:
            return "history"
        case .helpAndSupport:
            return "headphone"
        case .rate:
            return "star"
        case .invite:
            return "userGroup"
        case .rulesAndRegulations:
            return "infoCircle"
        case .privacyPolicy:
            return "caution"
        case .joinTelegram(let animation):
            return animation
        case .likeFacebook(let animation):
            return animation
        case .signOut:
            return "Sign Out"
        default:
            return ""
        }
    }
    
    var title: Any {
        switch self {
        case .redeemScore:
            return "স্কোর রিডিম করুন"
        case .requestPoint:
            return "রিকোয়েস্ট পয়েন্ট"
        case .giftPoint:
            return "গিফট পয়েন্ট"
        case .pointHistory:
            return "পয়েন্ট হিস্ট্রি"
        case .helpAndSupport:
            return "হেল্প অ্যান্ড সাপোর্ট"
        case .rate:
            return "রেট করুন"
        case .invite:
            return "ইনভাইট"
        case .rulesAndRegulations:
            return "নিয়ম ও শর্তাবলী"
        case .privacyPolicy:
            return "প্রাইভেসি পলিসি"
        case .joinTelegram:
            return "Win টেলিগ্রাম চ্যানেল"
        case .likeFacebook:
            return "Win ফেসবুক পেজ"
        case .signOut:
            return "সাইন আউট"
        default:
            return ""
        }
    }
    
    var description: String {
        switch self {
        case .joinTelegram:
            return "আপডেট পেতে জয়েন করুন"
        case .likeFacebook:
            return "আপডেট পেতে লাইক করুন"
        default:
            return ""
        }
    }
}

// Modify ProfileViewController.swift to VIPER design pattern. Create files in its own folder and maintain the folder, file, class, property etc nameing convention. Make the code readable, maintainable, efficient etc. You can ask if you need to ask anything before start to surve the purpose.


enum PointsType {
    case totalPoint(score: Int)
    case totalScore(score: Int)
    
    var typeLabel: String {
        switch self {
        case .totalPoint:
            return "মোট পয়েন্ট"
        case .totalScore:
            return "মোট স্কোর"
        }
    }
    
    var score: Int {
        switch self {
        case .totalPoint(let score),
             .totalScore(let score):
            return score
        }
    }
    
    var image: UIImage {
        switch self {
        case .totalPoint:
            return UIImage(resource: .starYellow3D)
        case .totalScore:
            return UIImage(resource: .coinTaka)
        }
    }
    
    var starBackground: UIColor {
        switch self {
        case .totalPoint:
            return .wcPinkLight
        case .totalScore:
            return .wcYellowLight
        }
    }
}

//
//
//  APIConstants.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 21/9/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import Foundation

enum OtpEvent: String {
    case signIn
    case signUp = "SignUp"
    case forgotPassword = "ForgotPassword"
}

enum APIConstants {
    
    static fileprivate var baseURL: URL {
        #if DEBUG
        return URL(string: "https://devapi.win2gain.com/api/")!
        #else
        return URL(string: "https://api.win2gain.com/api/")!
        #endif
    }
    
    static fileprivate var winWebURL: URL {
        #if DEBUG
        return URL(string: "https://dev.win2gain.com/")!
        #else
        return URL(string: "https://win2gain.com/")!
        #endif
    }
}

extension APIConstants {
    static var winWebHomeURL: String {
        return "\(winWebURL)home"
    }
    static func requestPointShareURL(receiversNumber: String, pointAmount: String) -> String {
        return "\(winWebURL)requestpoint?m=\(receiversNumber)&p=\(pointAmount)&t=1"
    }
}

extension APIConstants {
    // Authentication
    static var signInURL: String {
        return "\(baseURL)Users/SignIn"
    }
    static var signUpURL: String {
        return "\(baseURL)Users/Register"
    }
    static func otpRequestURL(msisdn: String, otpEvent: OtpEvent) -> String {
        return "\(baseURL)Users/RequestOtp?msisdn=88\(msisdn)&otpEvent=\(otpEvent.rawValue)"
    }
    static var otpVerificationURL: String {
        return "\(baseURL)Users/OtpVerification"
    }
    
    // Password Reset
    static func userRegistrationStatusURL(msisdn: String) -> String {
        return "\(baseURL)Users/IsUserLogin?msisdn=88\(msisdn)"
    }
    static var updatePasswordURL: String {
        return "\(baseURL)Users/UpdatePassword"
    }
}

extension APIConstants {
    // Leaderboard
    static var campaignListURL: String {
        return "\(baseURL)Leaderboards/GetCampaignList"
    }
    
    static func leaderboardCampaignURL(_ campaignID: Int) -> String {
        return "\(baseURL)Leaderboards/GetLeaderboardForCampaign?campaignId=\(campaignID)"
    }
}

extension APIConstants {
    // Home
    static var homeContentURL: String {
        return "\(baseURL)Home/HomeContent"
    }
    static var redemptionLeaderboardURL: String {
        return "\(baseURL)Home/GetRedemptionLeaderboard"
    }
    static var campaignsWithLeaderboardsURL: String {
        return "\(baseURL)Home/GetCampaignsWithLeaderboards"
    }
    static var onlineGamesStartURL: String {
        return "\(baseURL)OnlineGame/OnlineGameStart"
    }
}

extension APIConstants {
    // Subscription
    static var getWalletsURL: String {
        return "\(baseURL)Payment/GetWallets"
    }
    static func getPlansURL(_ walletID: Int) -> String {
        return "\(baseURL)Payment/GetPlans?walletId=\(walletID)"
    }
    // Payment Urls(GP)
    static var requestOTPFromGpURL: String {
        return "\(baseURL)PaymentGrameenphone/Initiate"
    }
    static var paymentCompletionFromGpURL: String {
        return "\(baseURL)PaymentGrameenphone/Pay"
    }
    // Payment Urls(Banglalink)
    static var requestOTPFromBanglalinkURL: String {
        return "\(baseURL)PaymentBanglalink/Initiate"
    }
    static var paymentCompletionFromBanglalinkURL: String {
        return "\(baseURL)PaymentBanglalink/Pay"
    }
    // Payment Urls(RobiAirtel)
    static var requestOTPFromRobiAirtelURL: String {
        return "\(baseURL)PaymentRobi/Subscription"
    }
    static var paymentCompletionFromRobiAirtelURL: String {
        return "\(baseURL)PaymentRobi/Pay"
    }
    // Payment Urls(Bkash)
    static var paymentBkashURL: String {
        return "\(baseURL)PaymentBkash/Subscription"
    }
}

extension APIConstants {
    // Profile
    static var userSummeryURL: String {
        return "\(baseURL)Users/GetUserSummary"
    }
    static var userAvatarURL: String {
        return "\(baseURL)Users/GetUserAvatar"
    }
    static var userAvatarListURL: String {
        return "\(baseURL)Users/AvatarList"
    }
    static var updateProfileURL: String {
        return "\(baseURL)Users/UpdateProfile"
    }
    static var totalPointURL: String {
        return "\(baseURL)Points/Details"
    }
    static var totalScoreURL: String {
        return "\(baseURL)Points/ScoreDetails"
    }
    // GIft Point
    static var getCouponListURL: String {
        return "\(baseURL)Points/GetCouponList"
    }
    static func getReceiverForTransferURL(_ msisdn: String) -> String {
        return "\(baseURL)Points/GetReceiverForTransfer?Msisdn=88\(msisdn)"
    }
    static var transferPointsURL: String {
        return "\(baseURL)Points/TransferPoints"
    }
    static var subscriptionHistoryURL: String {
        return "\(baseURL)Payment/GetBillingHistory"
    }
    static var helpAndSupportURL: String {
        return "\(baseURL)Misc/QuizHelpAndSupport"
    }
    static var invitationCodeURL: String {
        return "\(baseURL)Points/GetInvitationCode"
    }
    static var invitationHistoryURL: String {
        return "\(baseURL)Points/GetInvitationHistory"
    }
    static var rulesAndRegulationsURL: String {
        return "https://win2gain.com/condition?hideHeader=true"
    }
    static var privacyPolicyURL: String {
        return "https://win2gain.com/privacy-policy?hideHeader=true"
    }
}

//
//
//  AppConstants.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 21/9/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import Foundation

struct AppConstants {
    struct Auth {
        static let logInTitle = "সাইন ইন করুন"
        static let logInDescription = "মোবাইল নাম্বার এবং পাসওয়ার্ড দিয়ে সাইন ইন করুন"
        static let phoneNumberPlaceholder = "মোবাইল নম্বর"
        static let passwordPlaceholder = "পাসওয়ার্ড দিন"
        static let rememberMe = "আমাকে মনে রাখুন"
        static let forgotPassword = "পাসওয়ার্ড ভুলে গেছেন?"
        static let signIn = "সাইন ইন"
        static let signUp = "নিবন্ধন"
        static let notRegisteredYet = "এখনও নিবন্ধন করেননি?"
        static let registerNow = "নিবন্ধন করুন"
        static let otherwiseSignIn = "অথবা সাইন ইন করুন"
        static let signInWithGoogle = "গুগল দিয়ে সাইন ইন করুন"
        static let signInWithFacebook = "ফেসবুক দিয়ে সাইন ইন করুন"
        
        
        static let registerTitle = "নিবন্ধন করুন"
        static let registerDescription = "আপনার প্রয়োজনীয় তথ্য দিয়ে নিবন্ধন করুন"
        static let alreadyRegistered = "ইতিমধ্যে নিবন্ধন করেছেন?"
        static let doSignIn = "সাইন ইন করুন"
        static let provideInformationToRegister = "আপনার প্রয়োজনীয় তথ্য দিয়ে নিবন্ধন করুন"
        static let orDoSignUp = "অথবা নিবন্ধন করুন"
        static let writeReferrelCode = "রেফারেল কোড লিখুন (যদি থাকে)"
        static let registerWithGmail = "গুগল দিয়ে নিবন্ধন করুন"
        static let registerWithFacebook = "ফেসবুক দিয়ে নিবন্ধন করুন"
        
        static let mobileVerification = "মোবাইল ভেরিফিকেশন"
        static let otpSendToRegisteredMobileNumber = "নিবন্ধিত মোবাইল নম্বরে ওটিপি কোড পাঠানো হয়েছে।"
        static let typeOTP = "ওটিপি কোড লিখুন"
        static let otpNotReceived = "ওটিপি কোড পাননি?"
        static let sendAgain = "আবার পাঠান"
        static let pleaseWait = "অনুগ্রহপূর্বক অপেক্ষা করুন"
        static let doRegister = "নিবন্ধন করুন"
        static let completed = "সম্পন্ন হয়েছে"
        static let registrationCompleted = "নিবন্ধন সম্পন্ন হয়েছে"
        
        struct PasswordReset {
            static let phoneNumber = "মোবাইল নম্বর*"
            static let typeRegisteredPhoneNumber = "নিবন্ধিত মোবাইল নম্বর লিখুন"
        }
        
        struct NewPassword {
            static let enterNewPassword = "নতুন পাসওয়ার্ড লিখুন*"
            static let reenterPassword = "পাসওয়ার্ডটি পুনরায় লিখুন"
        }
    }
    
    struct Home {
        struct HomeMain {
        }
        struct Store {
            static let enterOTP = "ওটিপি কোড লিখুন*"
        }
    }
    
    struct Profile {
        static let pointsTitle = "অন্যান্য পয়েন্ট"
        
        struct UpdateProfile {
            static let updateButton = "অ্যাভাটার আপডেট করুন"
            static let phoneNumber = "01521717367"
            static let save = "সেভ করুন"
            static let submit = "সাবমিট করুন"
        }
        
        struct RequestPoint {
            static let senderNumberTitle = "প্রেরকের নম্বর"
            static let receiversNumberPlaceholder = "মোবাইল নম্বর"
            static let pointTypeTitle = "পয়েন্ট টাইপ"
            static let pointAmountTitle = "পয়েন্টের পরিমান"
            static let pointAmountPlaceholder = "পরিমান লিখুন"
            static let noteTitle = "নোট লিখুন (বাধ্যতামূলক নয়)"
            static let notePlaceholder = "প্রেরককে নোট লিখুন"
        }
        
        struct GiftPoint {
            static let receiversNumberTitle = "প্রাপকের নম্বর"
            static let receiversNumberPlaceholder = "মোবাইল নম্বর"
            static let pointTypeTitle = "পয়েন্ট টাইপ"
            static let pointAmountTitle = "পয়েন্টের পরিমান"
            static let pointAmountPlaceholder = "পরিমান লিখুন"
        }
        
        struct HelpAndSupport {
            static let yourFullName = "আপনার পুরো নাম*"
            static let phoneNumber = "মোবাইল নম্বর*"
            static let email = "ই-মেইল*"
            static let submit = "সাবমিট করুন"
            static let supportEmail = "সাপোর্ট ই-মেইল"
            static let win2gainEmail = "support@win2gain.com"
        }
        
        struct Invitation {
            static let invitationHeader = "ইনভাইট করুন"
            static let invitationDescription = "বন্ধুদের ইনভাইট করে পেয়ে যান"
            static let yourInvitationCode = "আপনার ইনভাইট কোড"
            static let copyCode = "কপি কোড"
            static let share = "শেয়ার করুন"
        }
    }
}

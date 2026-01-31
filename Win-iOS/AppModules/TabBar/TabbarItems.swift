//
//
//  TabbarItems.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 30/9/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

enum TabbarItems: CaseIterable {
    case scoreboard
    case home
    case profile
    
    var title: String {
        switch self {
        case .scoreboard:
            return "স্কোরবোর্ড"
        case .home:
            return ""
        case .profile:
            return "প্রোফাইল"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .scoreboard:
            return .winLeaderboard
        case .home:
            return UIImage()
        case .profile:
            return .winProfileCircle
        }
    }
}

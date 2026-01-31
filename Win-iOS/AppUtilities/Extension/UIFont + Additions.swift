//
//
//  UIFont + Additions.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 21/9/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

extension UIFont {
    enum NotoSansFont: String {
        case regular = "NotoSansBengali-Regular"
        case semiBold = "NotoSansBengali-SemiBold"
        case bold = "NotoSansBengali-Bold"
    }
    
    enum FontSize: CGFloat {
        case extraSmall = 12.0
        case small = 14.0
        case medium = 16.0
        case large = 18.0
        case extraLarge = 24.0
    }
    
    static func winFont(_ type: NotoSansFont, size: FontSize) -> UIFont {
        if let font = UIFont(name: type.rawValue, size: size.rawValue) {
            return font
        } else {
            return UIFont.systemFont(ofSize: size.rawValue)
        }
    }
}


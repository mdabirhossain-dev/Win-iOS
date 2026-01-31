//
//
//  UIColor + Additions.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 30/9/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

extension UIColor {
    
    convenience init(redInt: Int, greenInt: Int, blueInt: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat(redInt) / 255.0,
            green: CGFloat(greenInt) / 255.0,
            blue: CGFloat(blueInt) / 255.0,
            alpha: alpha
        )
    }
    
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        self.init(
            redInt: (hex >> 16) & 0xFF,
            greenInt: (hex >> 8) & 0xFF,
            blueInt: hex & 0xFF,
            alpha: alpha
        )
    }
}

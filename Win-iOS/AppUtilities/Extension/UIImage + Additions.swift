//
//
//  UIImage + Additions.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 9/11/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

// MARK: - UIImage resize helper
extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }.withRenderingMode(.alwaysOriginal)
    }
    
    func withPadding(_ insets: UIEdgeInsets) -> UIImage {
        let newSize = CGSize(
            width: size.width + insets.left + insets.right,
            height: size.height + insets.top + insets.bottom
        )
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
        draw(at: CGPoint(x: insets.left, y: insets.top))
        let padded = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return (padded ?? self).withRenderingMode(renderingMode)
    }
}


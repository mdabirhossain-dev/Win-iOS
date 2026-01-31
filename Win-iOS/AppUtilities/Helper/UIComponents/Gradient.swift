//
//
//  Gradient.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 1/12/25.
//  Contact me if anything is needed:
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit
import ObjectiveC

// MARK: - Gradient Direction
public enum GradientDirection {
    case vertical
    case horizontal
    case topLeftToBottomRight
    case topRightToBottomLeft
    case angle(_ degrees: CGFloat)
    case custom(start: CGPoint, end: CGPoint)
}

extension GradientDirection {
    var points: (start: CGPoint, end: CGPoint) {
        switch self {
        case .vertical:
            return (CGPoint(x: 0.5, y: 0.0), CGPoint(x: 0.5, y: 1.0))
        case .horizontal:
            return (CGPoint(x: 0.0, y: 0.5), CGPoint(x: 1.0, y: 0.5))
        case .topLeftToBottomRight:
            return (CGPoint(x: 0.0, y: 0.0), CGPoint(x: 1.0, y: 1.0))
        case .topRightToBottomLeft:
            return (CGPoint(x: 1.0, y: 0.0), CGPoint(x: 0.0, y: 1.0))
        case .angle(let degrees):
            return GradientDirection.points(forAngle: degrees)
        case .custom(let start, let end):
            return (start, end)
        }
    }

    private static func points(forAngle degrees: CGFloat) -> (start: CGPoint, end: CGPoint) {
        let radians = degrees * .pi / 180
        let dx = cos(radians)
        let dy = sin(radians)

        let length = sqrt(dx * dx + dy * dy)
        let ux = dx / length
        let uy = dy / length

        // Centered around (0.5, 0.5)
        let endX = 0.5 + ux * 0.5
        let endY = 0.5 - uy * 0.5   // invert y for UIKit coord system
        let startX = 0.5 - ux * 0.5
        let startY = 0.5 + uy * 0.5

        return (CGPoint(x: startX, y: startY),
                CGPoint(x: endX,   y: endY))
    }
}


//public enum GradientDirection {
//    case vertical
//    case horizontal
//    case topLeftToBottomRight
//    case topRightToBottomLeft
//    case angle(_ degrees: CGFloat)
//    case custom(start: CGPoint, end: CGPoint)
//}
//
//extension GradientDirection {
//    var points: (start: CGPoint, end: CGPoint) {
//        switch self {
//        case .vertical:
//            return (CGPoint(x: 0.5, y: 0.0), CGPoint(x: 0.5, y: 1.0))
//        case .horizontal:
//            return (CGPoint(x: 0.0, y: 0.5), CGPoint(x: 1.0, y: 0.5))
//        case .topLeftToBottomRight:
//            return (CGPoint(x: 0.0, y: 0.0), CGPoint(x: 1.0, y: 1.0))
//        case .topRightToBottomLeft:
//            return (CGPoint(x: 1.0, y: 0.0), CGPoint(x: 0.0, y: 1.0))
//        case .angle(let degrees):
//            return GradientDirection.points(forAngle: degrees)
//        case .custom(let start, let end):
//            return (start, end)
//        }
//    }
//
//    private static func points(forAngle degrees: CGFloat) -> (start: CGPoint, end: CGPoint) {
//        let radians = degrees * .pi / 180
//        let dx = cos(radians)
//        let dy = sin(radians)
//
//        let length = sqrt(dx * dx + dy * dy)
//        let ux = dx / length
//        let uy = dy / length
//
//        // Centered around (0.5, 0.5)
//        let endX = 0.5 + ux * 0.5
//        let endY = 0.5 - uy * 0.5   // invert y for UIKit coord system
//        let startX = 0.5 - ux * 0.5
//        let startY = 0.5 + uy * 0.5
//
//        return (CGPoint(x: startX, y: startY),
//                CGPoint(x: endX,   y: endY))
//    }
//}



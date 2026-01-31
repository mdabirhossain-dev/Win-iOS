//
//
//  WrappingFlowLayout.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 20/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//

import UIKit

final class WrappingFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attrs = super.layoutAttributesForElements(in: rect)?
            .map({ $0.copy() as! UICollectionViewLayoutAttributes }) else { return nil }

        var x = sectionInset.left
        var maxY: CGFloat = -1

        for attr in attrs where attr.representedElementCategory == .cell {
            if attr.frame.origin.y >= maxY {
                x = sectionInset.left
            }

            attr.frame.origin.x = x
            x += attr.frame.width + minimumInteritemSpacing
            maxY = max(maxY, attr.frame.maxY)
        }

        return attrs
    }
}

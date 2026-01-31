//
//
//  CarouselFlowLayout.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 13/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//

import UIKit

final class CarouselSnapFlowLayout: UICollectionViewFlowLayout {

    /// One big item, with peeking neighbors.
    /// itemWidth = collectionWidth - 60
    /// itemHeight = itemWidth * 16/9 (portrait), BUT capped via the table cell’s height constraint.
    func updateLayout() {
        guard let cv = collectionView, cv.bounds.width > 0 else { return }

        scrollDirection = .horizontal
        minimumLineSpacing = 10
        estimatedItemSize = .zero

        // Width rule: only 1 main item visible + peeks
        let itemW = max(0, cv.bounds.width - 60)

        // Portrait ratio (your rule): height = width * 16/9
        // NOTE: Actual height is capped by the collection view height constraint in the table cell.
        let rawH = itemW * 16.0 / 9.0
        let itemH = min(rawH, cv.bounds.height) // never exceed container height

        itemSize = CGSize(width: itemW, height: itemH)

        // Center horizontally (also creates peeking neighbors)
        let sideInset = max(0, (cv.bounds.width - itemW) / 2)

        // Center vertically so it doesn't appear "upside"/cut
        let verticalInset = max(0, (cv.bounds.height - itemH) / 2)

        sectionInset = UIEdgeInsets(top: verticalInset, left: sideInset, bottom: verticalInset, right: sideInset)

        cv.decelerationRate = .fast
    }

    override func prepare() {
        super.prepare()
        updateLayout()
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        true
    }

    /// Snap nearest cell to center
    override func targetContentOffset(forProposedContentOffset proposed: CGPoint,
                                      withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let cv = collectionView else { return proposed }

        let proposedCenterX = proposed.x + cv.bounds.width / 2
        let rect = CGRect(x: proposed.x, y: 0, width: cv.bounds.width, height: cv.bounds.height)

        guard let attrs = super.layoutAttributesForElements(in: rect) else { return proposed }

        var closest: UICollectionViewLayoutAttributes?
        for a in attrs where a.representedElementCategory == .cell {
            if closest == nil || abs(a.center.x - proposedCenterX) < abs(closest!.center.x - proposedCenterX) {
                closest = a
            }
        }

        guard let target = closest else { return proposed }
        return CGPoint(x: target.center.x - cv.bounds.width / 2, y: proposed.y)
    }
}

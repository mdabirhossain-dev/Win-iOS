//
//
//  CollectionSectionLayout.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 16/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//



import UIKit

// MARK: - Layout Specs
enum CollectionSectionLayout {
    /// Horizontal scrolling row: show N items on screen (N can be fractional like 2.5)
    case carousel(visibleCount: CGFloat,
                  aspectRatio: CGFloat, // height = width / aspectRatio  (e.g. 1.2 means wider than tall)
                  contentInsets: NSDirectionalEdgeInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16),
                  itemSpacing: CGFloat = 12,
                  scrolling: UICollectionLayoutSectionOrthogonalScrollingBehavior = .continuous)

    /// Vertical grid: fixed columns, vertical scrolling
    case grid(columns: Int,
              aspectRatio: CGFloat, // height = width / aspectRatio
              contentInsets: NSDirectionalEdgeInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16),
              interItemSpacing: CGFloat = 12,
              lineSpacing: CGFloat = 12)
}

struct CollectionLayoutFactory {
    static func makeLayout(_ sections: [CollectionSectionLayout]) -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { sectionIndex, env in
            guard sectionIndex < sections.count else { return nil }
            switch sections[sectionIndex] {
            case let .carousel(visibleCount, aspectRatio, insets, spacing, scrolling):
                return makeCarouselSection(
                    visibleCount: visibleCount,
                    aspectRatio: aspectRatio,
                    insets: insets,
                    spacing: spacing,
                    scrolling: scrolling,
                    env: env
                )

            case let .grid(columns, aspectRatio, insets, interItemSpacing, lineSpacing):
                return makeGridSection(
                    columns: columns,
                    aspectRatio: aspectRatio,
                    insets: insets,
                    interItemSpacing: interItemSpacing,
                    lineSpacing: lineSpacing,
                    env: env
                )
            }
        }
    }

    // MARK: - Builders
    private static func makeCarouselSection(
        visibleCount: CGFloat,
        aspectRatio: CGFloat,
        insets: NSDirectionalEdgeInsets,
        spacing: CGFloat,
        scrolling: UICollectionLayoutSectionOrthogonalScrollingBehavior,
        env: NSCollectionLayoutEnvironment
    ) -> NSCollectionLayoutSection {
        
        let containerW = env.container.effectiveContentSize.width
        let availableW = containerW - insets.leading - insets.trailing
        
        let fullItems = max(Int(floor(visibleCount)), 1)
        let gaps = max(fullItems, 0)

        let itemW = (availableW - CGFloat(gaps) * spacing) / max(visibleCount, 1)
        let itemH = itemW / max(aspectRatio, 0.0001)

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(itemW),
            heightDimension: .absolute(itemH)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(itemW),
            heightDimension: .absolute(itemH)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = insets
        section.interGroupSpacing = spacing
        section.orthogonalScrollingBehavior = scrolling

        return section
    }

//    private static func makeCarouselSection(
//        visibleCount: CGFloat,
//        aspectRatio: CGFloat,
//        insets: NSDirectionalEdgeInsets,
//        spacing: CGFloat,
//        scrolling: UICollectionLayoutSectionOrthogonalScrollingBehavior,
//        env: NSCollectionLayoutEnvironment
//    ) -> NSCollectionLayoutSection {
//
//        // Effective width inside safe-area etc.
//        let containerW = env.container.effectiveContentSize.width
//
//        // Subtract section insets
//        let availableW = containerW - insets.leading - insets.trailing
//
//        // visibleCount can be 2.5 -> there are (2.5 - 1) gaps "on screen"
//        let gaps = max(visibleCount - 1, 0)
//        let itemW = (availableW - gaps * spacing) / max(visibleCount, 1)
//
//        // height = width / aspectRatio (aspectRatio = width/height)
//        let itemH = itemW / max(aspectRatio, 0.0001)
//
//        let itemSize = NSCollectionLayoutSize(
//            widthDimension: .absolute(itemW),
//            heightDimension: .absolute(itemH)
//        )
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//
//        // 1 item per group, group scrolls horizontally
//        let groupSize = NSCollectionLayoutSize(
//            widthDimension: .absolute(itemW),
//            heightDimension: .absolute(itemH)
//        )
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//
//        let section = NSCollectionLayoutSection(group: group)
//        section.contentInsets = insets
//        section.interGroupSpacing = spacing
//        section.orthogonalScrollingBehavior = scrolling
//
//        return section
//    }

    private static func makeGridSection(
        columns: Int,
        aspectRatio: CGFloat,
        insets: NSDirectionalEdgeInsets,
        interItemSpacing: CGFloat,
        lineSpacing: CGFloat,
        env: NSCollectionLayoutEnvironment
    ) -> NSCollectionLayoutSection {

        let cols = max(columns, 1)
        let containerW = env.container.effectiveContentSize.width
        let availableW = containerW - insets.leading - insets.trailing

        // For N columns, there are (N - 1) inter-item gaps
        let totalGaps = CGFloat(cols - 1) * interItemSpacing
        let itemW = (availableW - totalGaps) / CGFloat(cols)
        let itemH = itemW / max(aspectRatio, 0.0001)

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(itemW),
            heightDimension: .absolute(itemH)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(itemH)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: cols)
        group.interItemSpacing = .fixed(interItemSpacing)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = insets
        section.interGroupSpacing = lineSpacing

        return section
    }
}

//
//
//  HomeFeaturesTableViewCell.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 17/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//


import UIKit

class HomeFeaturesTableViewCell: UITableViewCell {
    
    // MARK: - UI
    private var collectionHeightConstraint: NSLayoutConstraint?
    
    private lazy var collectionView: UICollectionView = {
        let layout = CollectionLayoutFactory.makeLayout([
            .grid(
                columns: 2,
                aspectRatio: 1.0, // square cells
                contentInsets: .init(top: 12, leading: 16, bottom: 12, trailing: 16),
                interItemSpacing: 12,
                lineSpacing: 12
            )
        ])
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false // important: let table handle scrolling
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(HomeGridItemsCollectionViewCell.self,
                    forCellWithReuseIdentifier: HomeGridItemsCollectionViewCell.className)
        return collectionView
    }()
    
    private var features: [DailyCheckIn] = []
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupView() {
        contentView.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        // Optional: dynamic height to fit content (no inner scrolling)
        collectionHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 1)
        collectionHeightConstraint?.priority = .defaultHigh
        collectionHeightConstraint?.isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCollectionHeightIfNeeded()
    }
    
    private func updateCollectionHeightIfNeeded() {
        // Force layout to get correct contentSize
        collectionView.layoutIfNeeded()
        let height = collectionView.collectionViewLayout.collectionViewContentSize.height
        if abs((collectionHeightConstraint?.constant ?? 0) - height) > 1 {
            collectionHeightConstraint?.constant = height
        }
    }
    
    // MARK: - Public API
    
    func configure(features: [DailyCheckIn]) {
        self.features = features
        collectionView.reloadData()
        setNeedsLayout()
        layoutIfNeeded()
        updateCollectionHeightIfNeeded()
    }
}

// MARK: - UICollectionViewDataSource

extension HomeFeaturesTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        features.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HomeGridItemsCollectionViewCell.className,
            for: indexPath
        ) as! HomeGridItemsCollectionViewCell
        
        let features = features[indexPath.item]
        cell.configure(title: features.featureTitle ?? "", imgURL: features.featureImage)
        cell.onButtonTap = { [weak self] in
            guard let self else { return }
            // Handle button tap per item
            print("Tapped button for item:", features.featureTitle)
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension HomeFeaturesTableViewCell: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let feature = features[indexPath.item]
//        print("Selected:", feature.featureTitle)
//    }
}

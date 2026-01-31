//
//
//  HomeBillboardsTableViewCell.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 13/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//


import UIKit

final class HomeBillboardsTableViewCell: UITableViewCell {

    private var billboardItems: [Billboard]?

    private lazy var carouselLayout: CarouselSnapFlowLayout = {
        CarouselSnapFlowLayout()
    }()

    private lazy var redeemptionWinerCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: carouselLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.dataSource = self
        cv.delegate = self
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.decelerationRate = .fast

        if #available(iOS 11.0, *) {
            cv.contentInsetAdjustmentBehavior = .never
        }

        cv.clipsToBounds = false
        cv.register(HomeBillboardCollectionViewCell.self, forCellWithReuseIdentifier: HomeBillboardCollectionViewCell.className)
        return cv
    }()

    private var heightConstraint: NSLayoutConstraint?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        selectionStyle = .none
        backgroundColor = .clear

        contentView.addSubview(redeemptionWinerCollectionView)
        NSLayoutConstraint.activate([
            redeemptionWinerCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            redeemptionWinerCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            redeemptionWinerCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            redeemptionWinerCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])

        let h = redeemptionWinerCollectionView.heightAnchor.constraint(equalToConstant: 220)
        h.isActive = true
        heightConstraint = h

        let bottom = redeemptionWinerCollectionView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12)
        bottom.priority = .required
        bottom.isActive = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // Update height from your ratio: height = width * (4/3)
        // (your current ratio choice)
        let w = contentView.bounds.width
        guard w > 0 else { return }

        let itemW = max(0, w - 60)
        let rawH = itemW * (4.0 / 3.0)

        // IMPORTANT: cap height so it never goes off-screen in a row
        // Adjust these if you want bigger/smaller cards.
        heightConstraint?.constant = rawH

        // Now let layout compute insets properly
        redeemptionWinerCollectionView.layoutIfNeeded()
        carouselLayout.updateLayout()
        carouselLayout.invalidateLayout()
    }

    func configure(billboards: [Billboard]?) {
        billboardItems = billboards
        redeemptionWinerCollectionView.reloadData()
    }
}

extension HomeBillboardsTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        billboardItems?.count ?? .zero
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeBillboardCollectionViewCell.className, for: indexPath) as! HomeBillboardCollectionViewCell
        guard let billboard = billboardItems?[indexPath.item], let title = billboard.title, let subTitle = billboard.subTitle else {
            cell.configure(title: "", subtitle: "", imgURL: nil)
            return cell
        }
        cell.configure(title: title, subtitle: subTitle, imgURL: billboard.image)
        return cell
    }

    // ✅ Force 1 item per screen with peeks
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemW = max(0, collectionView.bounds.width - 60)
        let rawH = itemW * (4.0 / 3.0)
        return CGSize(width: itemW, height: rawH)
    }
}

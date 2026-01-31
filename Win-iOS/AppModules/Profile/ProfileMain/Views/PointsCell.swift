//
//
//  PointsCell.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 7/10/25.
//  Contact me if anything is needed:
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

final class PointsCell: UICollectionViewCell {
    // MARK: - UI
    private let rootStackView: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let starContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let starImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(resource: .starRed3D))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(resource: .chevronRight))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let pointStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fill
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let pointsLabel: UILabel = {
        let label = UILabel()
        label.font = .winFont(.bold, size: .small)
        return label
    }()
    
    private let pointsTypeLabel: UILabel = {
        let label = UILabel()
        label.font = .winFont(.semiBold, size: .small)
        label.textColor = .gray
        return label
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupView() {
        contentView.backgroundColor = .white
        contentView.applyCornerRadious(8)
        contentView.applyShadow()
        
        contentView.addSubview(rootStackView)
        starContainerView.addSubview(starImageView)
        pointStackView.addArrangedSubviews([pointsLabel, pointsTypeLabel])
        rootStackView.addArrangedSubviews([starContainerView, pointStackView, arrowImageView])
        
        rootStackView.isLayoutMarginsRelativeArrangement = true
        rootStackView.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        NSLayoutConstraint.activate([
            rootStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            rootStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            rootStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            rootStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            starImageView.topAnchor.constraint(equalTo: starContainerView.topAnchor, constant: 6),
            starImageView.leadingAnchor.constraint(equalTo: starContainerView.leadingAnchor, constant: 6),
            starImageView.trailingAnchor.constraint(equalTo: starContainerView.trailingAnchor, constant: -6),
            starImageView.bottomAnchor.constraint(equalTo: starContainerView.bottomAnchor, constant: -6),
            
            starImageView.widthAnchor.constraint(equalToConstant: 24),
            starImageView.heightAnchor.constraint(equalToConstant: 24),
            arrowImageView.widthAnchor.constraint(equalToConstant: 24),
            arrowImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    // MARK: - Configure
    func configure(type: PointsType) {
        starContainerView.backgroundColor = type.starBackground
        starImageView.image = type.image
        pointsTypeLabel.text = type.typeLabel      // e.g. AppConstants.Profile.pointsTitle
        pointsLabel.text = "\(type.score)".dropLeading88().toBanglaNumberWithSuffix()
    }
}

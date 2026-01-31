//
//
//  TotalPointAndScoreBreakdownTableViewCell.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 18/11/25.
//  Contact me if anything is needed:
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

final class TotalPointAndScoreBreakdownTableViewCell: UITableViewCell {
    
    // MARK: - UI Properties
    private let rootStackView: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        return stack
    }()
    
    private let starContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    private let starImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .starYellow3D)
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
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let pointsTypeLabel: UILabel = {
        let label = UILabel()
        label.font = .winFont(.semiBold, size: .small)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        rootStackView.addArrangedSubviews([starContainerView, pointStackView])
        pointStackView.addArrangedSubviews([pointsLabel, pointsTypeLabel])
        
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
            starImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    // MARK: - Configure
    func configure(type: PointsType, walletTitle: String) {
        switch type {
        case .totalPoint:
            starContainerView.backgroundColor = .wcPinkLight
        case .totalScore:
            starContainerView.backgroundColor = .wcYellowLight
        }
        
        starImageView.image = type.image
        pointsLabel.text = "\(type.score)".toBanglaNumberWithSuffix()
        pointsTypeLabel.text = walletTitle
    }
}

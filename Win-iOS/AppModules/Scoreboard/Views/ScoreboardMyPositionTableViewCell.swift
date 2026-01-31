//
//
//  ScoreboardMyPositionTableViewCell.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 2/12/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

class ScoreboardMyPositionTableViewCell: UITableViewCell {
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let positionIndexLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .winFont(.semiBold, size: .small)
        label.backgroundColor = .clear
        label.padding = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        label.applyCornerRadious(12, borderWidth: 1, borderColor: .wcVelvetDark)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.applyCornerRadious(18)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let userInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let userPositionLabel: UILabel = {
        let label = UILabel()
        label.text = "আমার অবস্থান"
        label.font = .winFont(.regular, size: .small)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let msisdnLabel: UILabel = {
        let label = UILabel()
        label.font = .winFont(.semiBold, size: .small)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let pointsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .winFont(.semiBold, size: .small)
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
        contentView.backgroundColor = .wcYellowLight
        contentView.applyCornerRadious(8)
        contentView.applyShadow()
        
        contentView.addSubview(stackView)
        
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        spacer.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        stackView.addArrangedSubviews([positionIndexLabel, avatarImageView, userInfoStackView, spacer, pointsLabel])
        userInfoStackView.addArrangedSubviews([userPositionLabel, msisdnLabel])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            positionIndexLabel.widthAnchor.constraint(equalToConstant: 36),
            
            avatarImageView.widthAnchor.constraint(equalToConstant: 36),
            avatarImageView.heightAnchor.constraint(equalToConstant: 36),
            
            pointsLabel.widthAnchor.constraint(equalToConstant: 100),
        ])
    }
    
    func configure(_ info: LeaderboardItem?) {
        positionIndexLabel.text = "\(info?.userRank ?? 0)".toBanglaNumberWithSuffix()
        avatarImageView.setImage(from: info?.userAvatar ?? "")
        msisdnLabel.text = info?.msisdn?.toBanglaNumberWithSuffix().dropLeading88()
        pointsLabel.setImage(UIImage(resource: .coin), text: "\(info?.score ?? 0)".toBanglaNumberWithSuffix(), imageSize: CGSize(width: 24, height: 24))
    }
}

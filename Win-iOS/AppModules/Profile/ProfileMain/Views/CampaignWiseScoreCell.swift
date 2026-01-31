//
//
//  CampaignWiseScoreCell.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 17/12/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

final class CampaignWiseScoreCell: UICollectionViewCell {
    // MARK: - UI
    private let headerStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()

    private let campaignTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = .winFont(.semiBold, size: .medium)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private let scoreContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        view.applyCornerRadious(20)
        return view
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.numberOfLines = 1
        label.font = .winFont(.regular, size: .medium)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
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

    override func prepareForReuse() {
        super.prepareForReuse()
        campaignTitle.text = nil
        scoreLabel.text = nil
    }

    // MARK: - Setup
    private func setupView() {
        contentView.backgroundColor = .wcYellowLight
        contentView.applyCornerRadious(16)
        
        contentView.addSubview(headerStack)
        headerStack.addArrangedSubviews([campaignTitle, scoreContainer])
        scoreContainer.addSubview(scoreLabel)
        
        NSLayoutConstraint.activate([
            headerStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            headerStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            headerStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            headerStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            scoreLabel.topAnchor.constraint(equalTo: scoreContainer.layoutMarginsGuide.topAnchor),
            scoreLabel.leadingAnchor.constraint(equalTo: scoreContainer.layoutMarginsGuide.leadingAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: scoreContainer.layoutMarginsGuide.trailingAnchor),
            scoreLabel.bottomAnchor.constraint(equalTo: scoreContainer.layoutMarginsGuide.bottomAnchor),
            
            scoreContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: 40)
        ])
    }

    func configure(_ campaignTitle: String, _ score: Int) {
        self.campaignTitle.text = campaignTitle
        scoreLabel.text = "স্কোর: \(score)".toBanglaNumberWithSuffix()
    }
}

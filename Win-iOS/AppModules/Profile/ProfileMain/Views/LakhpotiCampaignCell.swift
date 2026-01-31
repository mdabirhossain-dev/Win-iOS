//
//
//  LakhpotiCampaignCell.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 8/10/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

class LakhpotiCampaignCell: UICollectionViewCell {
    // MARK: - UI
    private let rootStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .fill
        stack.isLayoutMarginsRelativeArrangement = true
//        stack.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        return stack
    }()
    
    private let headerStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 8
        return stack
    }()
    
    private let campaignTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "মিনিটেই লাখপতি"
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = .winFont(.bold, size: .large)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
    private let redeemButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("রিডিম করুন", for: .normal)
        button.setTitleColor(.wcVelvet, for: .normal)
        button.titleLabel?.font = .winFont(.semiBold, size: .medium)
        button.backgroundColor = .white
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        button.applyShadow()
        button.applyCornerRadious(20)
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        return button
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
        contentView.backgroundColor = .wcPinkLight
        contentView.applyShadow()
        contentView.applyCornerRadious(16)
        
        contentView.addSubview(rootStackView)
        rootStackView.addArrangedSubview(headerStack)
        headerStack.addArrangedSubviews([campaignTitle, redeemButton])
        
        NSLayoutConstraint.activate([
            rootStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            rootStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            rootStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            rootStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            redeemButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    @objc private func redeemButtonTapped() {
        
    }
}

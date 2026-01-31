//
//
//  SubscriptionHistoryTableViewCell.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 21/10/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

final class SubscriptionHistoryTableViewCell: UITableViewCell {
    
    // MARK: - UI Properties
    private let rootStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 12
        stack.alignment = .center
        stack.distribution = .fill
        return stack
    }()
    
    private let paymentStatusImageContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .wcGreenLight
        view.applyCornerRadious(16)
        return view
    }()
    
    private let paymentStatusImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "checkmark", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .wcGreen
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        return imageView
    }()
    
    private let pointBalanceAndPurchaseTimeStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 4
        stack.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return stack
    }()
    
    private let pointBalanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .winFont(.semiBold, size: .medium)
        label.numberOfLines = 1
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private let purchaseTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = .winFont(.regular, size: .extraSmall)
        label.numberOfLines = 1
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private let validityAndPaymentStatusRootStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .trailing
        stack.spacing = 4
        stack.setContentHuggingPriority(.required, for: .horizontal)
        stack.setContentCompressionResistancePriority(.required, for: .horizontal)
        return stack
    }()
    
    private let paymentAmountAndValidityStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .trailing
        stack.spacing = 4
        return stack
    }()
    
    private let paymentAmountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .winFont(.bold, size: .small)
        label.numberOfLines = 1
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    private let pointValidityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = .winFont(.regular, size: .small)
        label.numberOfLines = 1
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    private let paymentStatusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .wcGreen
        label.font = .winFont(.semiBold, size: .extraSmall)
        label.numberOfLines = 1
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
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
    
    // MARK: - Configure
    func configure(with history: SubscriptionHistory?) {
        guard
            let history,
            let points = history.points,
            let onDate = history.onDate,
            let priceInTaka = history.priceInTaka,
            let durationInDays = history.durationInDays,
            let actionType = history.actionType
        else { return }
        
        pointBalanceLabel.text = "\(points) পয়েন্ট"
        purchaseTimeLabel.text = onDate
        paymentAmountLabel.text = "৳\(priceInTaka)"
        pointValidityLabel.text = "/\(durationInDays) দিন"
        paymentStatusLabel.text = actionType.description
    }
    
    // MARK: - Setup
    private func setupView() {
        backgroundColor = .white
        applyCornerRadious(8)
        applyShadow()
        
        contentView.addSubview(rootStackView)
        
        rootStackView.addArrangedSubviews([
            paymentStatusImageContainerView,
            pointBalanceAndPurchaseTimeStackView,
            validityAndPaymentStatusRootStackView
        ])
        
        paymentStatusImageContainerView.addSubview(paymentStatusImageView)
        
        pointBalanceAndPurchaseTimeStackView.addArrangedSubviews([
            pointBalanceLabel,
            purchaseTimeLabel
        ])
        
        validityAndPaymentStatusRootStackView.addArrangedSubviews([
            paymentAmountAndValidityStackView,
            paymentStatusLabel
        ])
        
        paymentAmountAndValidityStackView.addArrangedSubviews([
            paymentAmountLabel,
            pointValidityLabel
        ])
        
        NSLayoutConstraint.activate([
            rootStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            rootStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            rootStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            rootStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            paymentStatusImageContainerView.widthAnchor.constraint(equalToConstant: 32),
            paymentStatusImageContainerView.heightAnchor.constraint(equalToConstant: 32),
            
            paymentStatusImageView.centerXAnchor.constraint(equalTo: paymentStatusImageContainerView.centerXAnchor),
            paymentStatusImageView.centerYAnchor.constraint(equalTo: paymentStatusImageContainerView.centerYAnchor),
            paymentStatusImageView.widthAnchor.constraint(equalToConstant: 20),
            paymentStatusImageView.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
}

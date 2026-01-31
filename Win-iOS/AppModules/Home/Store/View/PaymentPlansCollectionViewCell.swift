//
//
//  PaymentPlansCollectionViewCell.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 20/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//


import UIKit

final class PaymentPlansCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Callback
    var onTap: (() -> Void)?
    
    // MARK: - UI
    private let bonusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .winFont(.semiBold, size: .small)
        label.textColor = .black
        label.backgroundColor = .wcYellowLight.withAlphaComponent(0.5)
        label.padding = .init(top: 4, left: 8, bottom: 4, right: 8)
        label.textAlignment = .center
        label.clipsToBounds = true
        label.isHidden = true
        return label
    }()

    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(resource: .starYellow3D)
            .withPadding(UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .wcYellowLight
        imageView.layer.borderWidth = 1.5
        imageView.layer.borderColor = UIColor.wcYellow.cgColor
        imageView.clipsToBounds = true
        return imageView
    }()

    private let pointLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()

    private let paymentButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.font(.winFont(.semiBold, size: .medium), title: "খেলুন", color: .white)
        button.backgroundColor = .wcVelvet
        button.applyCornerRadious(16)
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
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

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = imageView.bounds.height / 2

        // bottom-left + bottom-right only
        bonusLabel.applyCornerRadius(12, corners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
    }

    // MARK: - Setup
    private func setupView() {
        contentView.backgroundColor = .white
        contentView.applyCornerRadious(12, borderWidth: 1, borderColor: .systemGray6)
        
        paymentButton.addTarget(self, action: #selector(didTapOnCell), for: .touchUpInside)

        contentView.addSubviews([contentStackView, bonusLabel])
        contentStackView.addArrangedSubviews([imageView, pointLabel, paymentButton])

        NSLayoutConstraint.activate([
            // bonus attached to top always
            bonusLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            bonusLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            bonusLabel.heightAnchor.constraint(equalToConstant: 22),

            contentStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            contentStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            contentStackView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 12),
            contentStackView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 12),
            contentStackView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -12),
            contentStackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12),

            imageView.widthAnchor.constraint(equalToConstant: 48),
            imageView.heightAnchor.constraint(equalToConstant: 48),

            paymentButton.heightAnchor.constraint(equalToConstant: 32),
        ])
    }

    // MARK: - Configure
    func configure(plan: PurchasePlan) {
        let price = plan.price ?? 0
        let validity = plan.durationInDays ?? 0
        var priceAndDuration: String
        if validity < 1 {
            priceAndDuration = "৳\(price)".toBanglaNumberWithSuffix()
        } else {
            priceAndDuration = ("৳\(price)" + "/\(validity) দিন").toBanglaNumberWithSuffix()
        }
        pointLabel.attributedText = makePointsAttributedText(firstHalfText: "\(plan.points ?? .zero)".toBanglaNumberWithSuffix(), secondHalfText: " পয়েন্ট")
        paymentButton.font(.winFont(.semiBold, size: .medium), title: priceAndDuration, color: .white)
        
        let bonus = plan.bonusPercentage ?? 0
        if bonus > 0 {
            bonusLabel.isHidden = false
            bonusLabel.text = "+\(bonus)% বোনাস".toBanglaNumberWithSuffix()
        } else {
            bonusLabel.isHidden = true
            bonusLabel.text = nil
        }
    }

    private func makePointsAttributedText(firstHalfText: String, firstHalfFont: UIFont = .winFont(.semiBold, size: .medium), secondHalfText: String, secondHalfFont: UIFont = .winFont(.regular, size: .medium)) -> NSAttributedString {
        let result = NSMutableAttributedString(
            string: firstHalfText,
            attributes: [.font: firstHalfFont, .foregroundColor: UIColor.label]
        )

        result.append(NSAttributedString(
            string: secondHalfText,
            attributes: [.font: secondHalfFont, .foregroundColor: UIColor.label]
        ))

        return result
    }
    
    @objc private func didTapOnCell() {
        onTap?()
    }
}

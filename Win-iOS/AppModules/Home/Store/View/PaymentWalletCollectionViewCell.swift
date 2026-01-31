//
//
//  PaymentWalletCollectionViewCell.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 20/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//


import UIKit

final class PaymentWalletCollectionViewCell: UICollectionViewCell {

    // MARK: - UI
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .winFont(.regular, size: .small)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        contentView.applyCornerRadious(20, borderWidth: 1, borderColor: .systemGray6)
        contentView.backgroundColor = .wcPinkLight

        contentView.addSubview(stackView)
        stackView.addArrangedSubviews([imageView, titleLabel])

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),

            imageView.widthAnchor.constraint(equalToConstant: 24),
            imageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    func configure(title: String?, imgURL: String?, isSelected: Bool) {
        titleLabel.text = title
        if let imgURL, !imgURL.isEmpty { imageView.setImage(from: imgURL) } else { imageView.image = nil }

        if isSelected {
            contentView.backgroundColor = .wcPinkLight
            contentView.layer.borderColor = UIColor.wcVelvet.cgColor
            titleLabel.textColor = .wcVelvet
        } else {
            contentView.backgroundColor = .white
            contentView.layer.borderColor = UIColor.systemGray6.cgColor
            titleLabel.textColor = .gray
        }
    }
}

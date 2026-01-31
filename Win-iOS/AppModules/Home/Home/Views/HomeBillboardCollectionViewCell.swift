//
//
//  HomeBillboardCollectionViewCell.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 13/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//


import UIKit

final class HomeBillboardCollectionViewCell: UICollectionViewCell {

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.setContentHuggingPriority(.defaultLow, for: .vertical)
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .winFont(.semiBold, size: .extraLarge)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray4
        label.font = .winFont(.regular, size: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let playButton: WinButton = {
        let button = WinButton(height: 40, textColor: .wcVelvetDark, background: .solid(.white))
        button.font(.winFont(.regular, size: .medium), title: "খেলুন", color: .wcVelvetDark)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private var imageSquareConstraint: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        contentView.backgroundColor = .clear
        applyGradient(colors: [.wcVelvet, .wcPink], direction: .vertical, cornerRadius: 16)

        contentView.addSubview(stackView)
        stackView.addArrangedSubviews([imageView, titleLabel, descriptionLabel, playButton])
        
        let square = imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        square.priority = .defaultHigh
        square.isActive = true
        imageSquareConstraint = square

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            imageView.widthAnchor.constraint(equalTo: stackView.widthAnchor),

            playButton.widthAnchor.constraint(equalTo: stackView.widthAnchor),
        ])

        stackView.setCustomSpacing(16, after: imageView)
        stackView.setCustomSpacing(8, after: titleLabel)
        stackView.setCustomSpacing(16, after: descriptionLabel)
    }

    func configure(title: String, subtitle: String, imgURL: String?) {
        titleLabel.text = title
        descriptionLabel.text = subtitle
        if let imageURL = imgURL {
            imageView.setImage(from: imageURL)
        }
    }
}

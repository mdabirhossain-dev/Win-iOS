//
//
//  HomeBannerTableViewCell.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 13/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//


import UIKit

class HomeBannerTableViewCell: UITableViewCell {
    
    // MARK: - Public
    var onTap: (() -> Void)?

    // MARK: - UI
    private let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.applyGradient(colors: [.wcVelvet, .wcPink, .wcYellowLight], direction: .horizontal, cornerRadius: 16)
        view.applyShadow()
        return view
    }()

    private let rootStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 16
        stack.alignment = .center
        stack.distribution = .fill
        return stack
    }()

    private let textStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 6
        stack.alignment = .leading
        stack.distribution = .fillEqually
        return stack
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .winFont(.bold, size: .large)
        label.textColor = .white
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.font = .winFont(.regular, size: .medium)
        label.textColor = .white
        return label
    }()

    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.black, for: .normal)
        button.font(.winFont(.semiBold, size: .extraSmall), title: "ট্যাপ করুন")
        button.backgroundColor = .white
        button.applyCornerRadious(16)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return button
    }()

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        cardView.layer.shadowPath = UIBezierPath(
            roundedRect: cardView.bounds,
            cornerRadius: cardView.layer.cornerRadius
        ).cgPath
    }

    // MARK: - Setup
    private func commonInit() {
        selectionStyle = .none
        contentView.backgroundColor = .clear

        contentView.addSubview(cardView)
        cardView.addSubview(rootStackView)

        // Left
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(descriptionLabel)
        textStackView.setCustomSpacing(14, after: descriptionLabel)
        textStackView.addArrangedSubview(actionButton)

        // Right
        rootStackView.addArrangedSubview(textStackView)
        rootStackView.addArrangedSubview(iconImageView)

        NSLayoutConstraint.activate([
            // Card insets
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            rootStackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            rootStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16),
            rootStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            rootStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            
            iconImageView.widthAnchor.constraint(equalToConstant: 92),
            iconImageView.heightAnchor.constraint(equalToConstant: 92),
            
            actionButton.heightAnchor.constraint(equalToConstant: 32),
            actionButton.widthAnchor.constraint(equalToConstant: 92),
        ])
    }

    // MARK: - Configure
    func configure(
        title: String,
        subtitle: String,
        imgURL: String?
    ) {
        titleLabel.text = title
        descriptionLabel.text = subtitle
        if let imageURL = imgURL {
            iconImageView.setImage(from: imageURL)
        }
    }

    @objc private func didTapButton() {
        onTap?()
    }
}

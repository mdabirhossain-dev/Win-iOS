//
//
//  HomeWatchLiveTableViewCell.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 19/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//

import UIKit

final class HomeWatchLiveTableViewCell: UITableViewCell {

    private enum Constants {
        static let cornerRadius: CGFloat = 12
        static let horizontalInset: CGFloat = 16
        static let verticalInset: CGFloat = 14

        static let stackSpacing: CGFloat = 12
        static let textSpacing: CGFloat = 6

        static let animationSize: CGFloat = 48
        static let chevronSize: CGFloat = 28
        static let chevronLeadingSpace: CGFloat = 6
        
        static let minCellHeight: CGFloat = 96
    }

    // MARK: - UI
    private let rootStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Constants.stackSpacing
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let animationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()

    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = Constants.textSpacing
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        stackView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return stackView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .winFont(.regular, size: .medium)
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .winFont(.bold, size: .medium)
        return label
    }()

    private let rightImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        return imageView
    }()

    private var minHeightConstraint: NSLayoutConstraint?

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
        selectionStyle = .none
        backgroundColor = .clear

        contentView.backgroundColor = .wcPinkLight
        contentView.applyCornerRadious(Constants.cornerRadius)
        contentView.applyShadow()

        contentView.addSubview(rootStackView)
        rootStackView.addArrangedSubviews([animationView, contentStackView, rightImageView])
        contentStackView.addArrangedSubviews([titleLabel, descriptionLabel])
        
        minHeightConstraint = contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: Constants.minCellHeight)
        minHeightConstraint?.isActive = true

        NSLayoutConstraint.activate([
            rootStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.verticalInset),
            rootStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalInset),
            rootStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalInset),
            rootStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.verticalInset),

            animationView.widthAnchor.constraint(equalToConstant: Constants.animationSize),
            animationView.heightAnchor.constraint(equalToConstant: Constants.animationSize),

            rightImageView.widthAnchor.constraint(equalToConstant: Constants.chevronSize),
            rightImageView.heightAnchor.constraint(equalToConstant: Constants.chevronSize)
        ])

        // tiny breathing space between text and chevron (without extra wrapper)
        rootStackView.setCustomSpacing(Constants.chevronLeadingSpace, after: contentStackView)
    }

    // MARK: - Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        animationView.subviews.forEach { $0.removeFromSuperview() }
        titleLabel.text = nil
        descriptionLabel.text = nil
    }

    // MARK: - Configure
    func configure(_ title: String) {
        titleLabel.text = "সরাসরি দেখুন"
        descriptionLabel.text = title

        animationView.subviews.forEach { $0.removeFromSuperview() }

        let lottieView = LottieAnimationViewContainer()
        lottieView.translatesAutoresizingMaskIntoConstraints = false
        lottieView.setAnimation(named: .camera, loopMode: .loop)

        animationView.addSubview(lottieView)

        NSLayoutConstraint.activate([
            lottieView.topAnchor.constraint(equalTo: animationView.topAnchor),
            lottieView.leadingAnchor.constraint(equalTo: animationView.leadingAnchor),
            lottieView.trailingAnchor.constraint(equalTo: animationView.trailingAnchor),
            lottieView.bottomAnchor.constraint(equalTo: animationView.bottomAnchor)
        ])
    }
}

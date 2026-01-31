//
//
//  ScoreBreakdownView.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 1/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//


import UIKit

// MARK: - ScoreBreakdownView
final class ScoreBreakdownView: UIView {

    private let rootStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 12
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.setContentHuggingPriority(.required, for: .vertical)
        stackView.setContentCompressionResistancePriority(.required, for: .vertical)
        return stackView
    }()

    private let pointStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let pointImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(resource: .starYellow3D))
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let totalPointNumberLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .wcVelvet
        label.font = .winFont(.semiBold, size: .large)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let totalPointLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = .winFont(.regular, size: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        applyCornerRadious(8)

        addSubview(rootStackView)
        rootStackView.addArrangedSubviews([
            pointStackView,
            totalPointLabel
        ])
        pointStackView.addArrangedSubviews([
            pointImageView,
            totalPointNumberLabel
        ])

        let margins = layoutMarginsGuide

        NSLayoutConstraint.activate([
            rootStackView.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
            rootStackView.topAnchor.constraint(equalTo: margins.topAnchor),
            rootStackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            rootStackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            rootStackView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),

            pointImageView.heightAnchor.constraint(equalToConstant: 28),
            pointImageView.widthAnchor.constraint(equalToConstant: 28)
        ])
    }

    func configure(_ pointBreakdown: PointBreakdown) {
        if pointBreakdown.walletId == 0 {
            backgroundColor = .wcYellowLight
        } else {
            backgroundColor = .wcPinkLight
        }

        totalPointNumberLabel.text = pointBreakdown.score?.toBanglaNumberWithSuffix()
        totalPointLabel.text = "\(pointBreakdown.walletTitle ?? "") পয়েন্ট"
    }
}

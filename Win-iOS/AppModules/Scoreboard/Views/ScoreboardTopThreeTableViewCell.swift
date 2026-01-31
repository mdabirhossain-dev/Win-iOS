//
//
//  ScoreboardTopThreeTableViewCell.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 30/11/25.
//  Contact me if anything is needed:
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//

import UIKit

// MARK: - Always-circular image view
private final class CircularImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
        layer.masksToBounds = true
        layer.cornerCurve = .continuous
        layer.cornerRadius = min(bounds.width, bounds.height) / 2
    }
}

// MARK: - Small UI factories (kills boilerplate)
private extension UIStackView {
    static func make(
        axis: NSLayoutConstraint.Axis,
        alignment: UIStackView.Alignment,
        distribution: UIStackView.Distribution,
        spacing: CGFloat
    ) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.alignment = alignment
        stackView.distribution = distribution
        stackView.spacing = spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
}

private extension UILabel {
    static func make(font: UIFont, color: UIColor, alignment: NSTextAlignment) -> UILabel {
        let label = UILabel()
        label.font = font
        label.textColor = color
        label.textAlignment = alignment
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }
}

private extension UIView {
    static func make() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = false
        return view
    }
}

private extension UIImageView {
    static func make(image: UIImage? = nil, contentMode: UIView.ContentMode, hidden: Bool = false) -> UIImageView {
        let view = UIImageView(image: image)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = contentMode
        view.isHidden = hidden
        return view
    }
}

// MARK: - Cell
final class ScoreboardTopThreeTableViewCell: UITableViewCell {
    
    private let horizontalStackView = UIStackView.make(
        axis: .horizontal,
        alignment: .bottom,
        distribution: .fillEqually,
        spacing: 10
    )
    
    private let leftCard = ScoreboardTopThreeCardView()
    private let centerCard = ScoreboardTopThreeCardView()
    private let rightCard = ScoreboardTopThreeCardView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupViews()
        applyStaticRankStyling()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        leftCard.reset()
        centerCard.reset()
        rightCard.reset()
        applyStaticRankStyling()
    }
    
    private func setupViews() {
        backgroundColor = .clear
        contentView.addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubviews([leftCard, centerCard, rightCard])
        
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            horizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            horizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            horizontalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    private func applyStaticRankStyling() {
        centerCard.applyRank(.first, prominent: true)
        leftCard.applyRank(.second, prominent: false)
        rightCard.applyRank(.third, prominent: false)
    }
    
    func configure(_ items: [LeaderboardItem]) {
        leftCard.isHidden = true
        centerCard.isHidden = true
        rightCard.isHidden = true
        
        if items.indices.contains(0) { centerCard.isHidden = false; centerCard.configure(with: items[0]) }
        if items.indices.contains(1) { leftCard.isHidden = false; leftCard.configure(with: items[1]) }
        if items.indices.contains(2) { rightCard.isHidden = false; rightCard.configure(with: items[2]) }
    }
}

// MARK: - Card
private final class ScoreboardTopThreeCardView: UIView {
    
    enum Rank {
        case first, second, third
        
        var assetName: String {
            switch self {
            case .first:  return "starFirst"
            case .second: return "starSecond"
            case .third:  return "starThird"
            }
        }
        
        var borderColor: UIColor {
            switch self {
            case .first:  return .wcVelvet
            case .second: return .wcYellow
            case .third:  return .systemGray3
            }
        }
    }
    
    private static let assetBundle = Bundle(for: ScoreboardTopThreeCardView.self)
    
    private let badgeSize: CGFloat = 28
    private let avatarInset: CGFloat = 4
    private let badgeBottomPad: CGFloat = 6
    private let firstRankTopExtraSpace: CGFloat = 12
    
    private let verticalStack = UIStackView.make(
        axis: .vertical,
        alignment: .fill,
        distribution: .fill,
        spacing: 6
    )
    
    private let msisdnLabel = UILabel.make(
        font: .winFont(.semiBold, size: .extraSmall),
        color: .label,
        alignment: .center
    )
    
    private let redeemStatusView: AutoSwipingBadgeView = {
        let view = AutoSwipingBadgeView(
            configuration: .init(
                interval: 3.0,
                animationDuration: 0.35,
                font: .winFont(.semiBold, size: .extraSmall),
                textColor: .wcGreen,
                background: [.wcGreenLight.withAlphaComponent(0.3), .wcBackground],
                horizontalPadding: 10,
                size: CGSize(width: .zero, height: 24)
            )
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(.required, for: .horizontal)
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        return view
    }()
    
    private let crownImageView = UIImageView.make(
        image: UIImage(resource: .crown),
        contentMode: .scaleAspectFit,
        hidden: true
    )
    
    private let avatarContainer = UIView.make()
    private let avatarWrapper = UIView.make()
    
    private let avatarImageView: CircularImageView = {
        let view = CircularImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private let starBadgeImageView: CircularImageView = {
        let view = CircularImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private var minHeightRatioConstraint: NSLayoutConstraint?
    private var avatarWrapperTopConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCard()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func reset() {
        msisdnLabel.text = nil
        avatarImageView.image = nil
        redeemStatusView.isHidden = true
        crownImageView.isHidden = true
        
        avatarWrapperTopConstraint?.constant = avatarInset
        
        avatarImageView.layer.borderWidth = 0
        avatarImageView.layer.borderColor = UIColor.clear.cgColor
    }
    
    func applyRank(_ rank: Rank, prominent: Bool) {
        starBadgeImageView.image = UIImage(named: rank.assetName, in: Self.assetBundle, compatibleWith: nil)
        setMinHeightRatio(prominent ? (18.0 / 9.0) : (16.0 / 9.0))
        
        crownImageView.isHidden = (rank != .first)
        avatarWrapperTopConstraint?.constant = (rank == .first) ? (avatarInset + firstRankTopExtraSpace) : avatarInset
        
        avatarImageView.layer.borderWidth = 2
        avatarImageView.layer.borderColor = rank.borderColor.cgColor
    }
    
    func configure(with item: LeaderboardItem) {
        msisdnLabel.text = item.msisdn?.toBanglaNumberWithSuffix().dropLeading88()
        avatarImageView.setImage(from: item.userAvatar ?? "")
        
        if let totalRedeemAmount = item.totalRedeemAmount, totalRedeemAmount > 0 {
            redeemStatusView.isHidden = false
            redeemStatusView.setItems(["রিডিমড", "৳\(totalRedeemAmount.toBanglaNumberWithSuffix())"])
        } else {
            redeemStatusView.isHidden = true
        }
        
        setNeedsLayout()
    }
    
    private func setupCard() {
        translatesAutoresizingMaskIntoConstraints = false
        directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        applyGradient(colors: [.systemGray5, .wcBackground.withAlphaComponent(0)], direction: .vertical, cornerRadius: 8)
        
        addSubview(verticalStack)
        verticalStack.addArrangedSubviews([avatarContainer, msisdnLabel, redeemStatusView])
        
        setupAvatar()
        
        NSLayoutConstraint.activate([
            verticalStack.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            verticalStack.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            verticalStack.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            verticalStack.bottomAnchor.constraint(lessThanOrEqualTo: layoutMarginsGuide.bottomAnchor),
            redeemStatusView.heightAnchor.constraint(equalToConstant: 24),
        ])
        
        setMinHeightRatio(16.0 / 9.0)
    }
    
    private func setupAvatar() {
        avatarContainer.addSubviews([crownImageView, avatarWrapper, starBadgeImageView])
        avatarWrapper.addSubview(avatarImageView)
        
        let wrapperSquare = avatarWrapper.heightAnchor.constraint(equalTo: avatarWrapper.widthAnchor)
        wrapperSquare.priority = .required
        
        let topC = avatarWrapper.topAnchor.constraint(equalTo: avatarContainer.topAnchor, constant: avatarInset)
        avatarWrapperTopConstraint = topC
        
        NSLayoutConstraint.activate([
            topC,
            avatarWrapper.leadingAnchor.constraint(equalTo: avatarContainer.leadingAnchor, constant: avatarInset),
            avatarWrapper.trailingAnchor.constraint(equalTo: avatarContainer.trailingAnchor, constant: -avatarInset),
            avatarWrapper.bottomAnchor.constraint(equalTo: avatarContainer.bottomAnchor,
                                                  constant: -((badgeSize * 0.5) + badgeBottomPad)),
            wrapperSquare,
            
            // crown (kept EXACTLY like your working behavior)
            crownImageView.centerXAnchor.constraint(equalTo: avatarWrapper.centerXAnchor),
            crownImageView.bottomAnchor.constraint(equalTo: avatarWrapper.topAnchor, constant: 4),
            crownImageView.widthAnchor.constraint(equalToConstant: badgeSize),
            crownImageView.heightAnchor.constraint(equalToConstant: badgeSize),
            
            avatarImageView.topAnchor.constraint(equalTo: avatarWrapper.topAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: avatarWrapper.leadingAnchor),
            avatarImageView.trailingAnchor.constraint(equalTo: avatarWrapper.trailingAnchor),
            avatarImageView.bottomAnchor.constraint(equalTo: avatarWrapper.bottomAnchor),
            
            starBadgeImageView.widthAnchor.constraint(equalToConstant: badgeSize),
            starBadgeImageView.heightAnchor.constraint(equalToConstant: badgeSize),
            starBadgeImageView.centerXAnchor.constraint(equalTo: avatarWrapper.centerXAnchor),
            starBadgeImageView.centerYAnchor.constraint(equalTo: avatarWrapper.bottomAnchor)
        ])
    }
    
    private func setMinHeightRatio(_ ratio: CGFloat) {
        minHeightRatioConstraint?.isActive = false
        let c = heightAnchor.constraint(greaterThanOrEqualTo: widthAnchor, multiplier: ratio)
        c.priority = .required
        c.isActive = true
        minHeightRatioConstraint = c
    }
}

//
//
//  SectionHeaderView.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 13/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//


import UIKit

final class SectionHeaderView: UIView {

    // MARK: - Public
    var onTapSeeAll: (() -> Void)?

    /// Hidden by default. Set `true` when you need it.
    var showsSeeAll: Bool = false {
        didSet { seeAllButton.isHidden = !showsSeeAll }
    }

    // MARK: - UI
    private let rootStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 12
        return stack
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textColor = .wcVelvetDark
        label.font = .winFont(.semiBold, size: .large)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()

    private let seeAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.font(.winFont(.regular, size: .small), title: "সব দেখুন >", color: .wcVelvet)
        button.contentEdgeInsets = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        button.isHidden = true // default hidden
        return button
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear

        addSubview(rootStack)
        rootStack.addArrangedSubview(titleLabel)
        rootStack.addArrangedSubview(seeAllButton)

        seeAllButton.addTarget(self, action: #selector(didTapSeeAll), for: .touchUpInside)

        NSLayoutConstraint.activate([
            rootStack.topAnchor.constraint(equalTo: topAnchor),
            rootStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            rootStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            rootStack.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])

        // Ensure correct initial state even if someone sets showsSeeAll later
        seeAllButton.isHidden = !showsSeeAll
    }

    // MARK: - Configure
    func setTitle(_ title: String) {
        titleLabel.text = title
    }

    func setSeeAllTitle(_ title: String = "সব দেখুন >") {
        seeAllButton.setTitle(title, for: .normal)
    }

    func setStyles(
        titleFont: UIFont = .winFont(.semiBold, size: .large),
        titleColor: UIColor = .wcVelvetDark,
        seeAllFont: UIFont = .winFont(.regular, size: .small),
        seeAllColor: UIColor = .wcVelvet
    ) {
        titleLabel.font = titleFont
        titleLabel.textColor = titleColor
        seeAllButton.font(seeAllFont, color: seeAllColor)
        seeAllButton.setTitleColor(seeAllColor, for: .normal)
    }

    @objc private func didTapSeeAll() {
        guard showsSeeAll else { return }
        onTapSeeAll?()
    }
}

final class CollectionViewHeader: UICollectionReusableView {

    static let reuseId = String(describing: SectionHeaderView.self)

    // MARK: - Public
    var onTapSeeAll: (() -> Void)?

    /// Hidden by default. Set `true` when you need it.
    var showsSeeAll: Bool = false {
        didSet { seeAllButton.isHidden = !showsSeeAll }
    }

    // MARK: - UI
    private let rootStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 12
        return stackView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textColor = .wcVelvetDark
        label.font = .winFont(.semiBold, size: .large)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()

    private let seeAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.font(.winFont(.regular, size: .small), title: "সব দেখুন >", color: .systemGray5)
        button.contentEdgeInsets = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        button.isHidden = true
        return button
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        backgroundColor = .clear

        addSubview(rootStackView)
        rootStackView.addArrangedSubview(titleLabel)
        rootStackView.addArrangedSubview(seeAllButton)

        seeAllButton.addTarget(self, action: #selector(didTapSeeAll), for: .touchUpInside)

        NSLayoutConstraint.activate([
            rootStackView.topAnchor.constraint(equalTo: topAnchor),
            rootStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            rootStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            rootStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        seeAllButton.isHidden = !showsSeeAll
    }

    // MARK: - Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        onTapSeeAll = nil
        showsSeeAll = false
        titleLabel.text = nil
        seeAllButton.setTitle("সব দেখুন >", for: .normal)
    }

    // MARK: - Configure
    func setTitle(_ title: String, color: UIColor? = nil) {
        titleLabel.text = title
        if let color = color {
            titleLabel.textColor = color
        }
    }

    func setSeeAllTitle(_ title: String, color: UIColor = .systemGray5) {
        seeAllButton.font(.winFont(.regular, size: .small), title: title, color: color)
    }

    func setStyles(
        titleFont: UIFont = .winFont(.semiBold, size: .large),
        titleColor: UIColor = .wcVelvetDark,
        seeAllFont: UIFont = .winFont(.regular, size: .small),
        seeAllColor: UIColor = .systemGray5
    ) {
        titleLabel.font = titleFont
        titleLabel.textColor = titleColor
        seeAllButton.font(seeAllFont, color: seeAllColor)
        seeAllButton.setTitleColor(seeAllColor, for: .normal)
    }

    @objc private func didTapSeeAll() {
        guard showsSeeAll else { return }
        onTapSeeAll?()
    }
}

//
//
//  HomeFreePointTableViewCell.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 18/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//


import UIKit

final class HomeFreePointTableViewCell: UITableViewCell {

    // MARK: - Callbacks
    var onJourneyButtonTap: ((_ journey: Invite?, _ index: Int) -> Void)?

    // MARK: - UI
    private let rootStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let headerView: SectionHeaderView = {
        let header = SectionHeaderView()
        header.setTitle("ফ্রি পয়েন্ট জিতুন")
        return header
    }()

    private var collectionHeightConstraint: NSLayoutConstraint?

    private lazy var collectionView: UICollectionView = {
        let layout = CollectionLayoutFactory.makeLayout([
            .grid(
                columns: 3,
                aspectRatio: 0.75,
                contentInsets: .init(top: 12, leading: 16, bottom: 12, trailing: 16),
                interItemSpacing: 12,
                lineSpacing: 12
            )
        ])

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            FreePointsCollectionViewCell.self,
            forCellWithReuseIdentifier: FreePointsCollectionViewCell.className
        )
        return collectionView
    }()

    private var userJourneyProgress: [UserJourneyProgress] = []

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Setup
    private func setupView() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        contentView.addSubview(rootStackView)
        rootStackView.addArrangedSubviews([headerView, collectionView])

        let heightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 1)
        heightConstraint.priority = .defaultHigh
        collectionHeightConstraint = heightConstraint

        NSLayoutConstraint.activate([
            rootStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            rootStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            rootStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            rootStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            heightConstraint
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateCollectionHeightIfNeeded()
    }

    private func updateCollectionHeightIfNeeded() {
        collectionView.layoutIfNeeded()
        let height = collectionView.collectionViewLayout.collectionViewContentSize.height

        if let collectionHeightConstraint, abs(collectionHeightConstraint.constant - height) > 1 {
            collectionHeightConstraint.constant = height
        }
    }

    // MARK: - Public API
    func configure(_ userJourneyProgress: [UserJourneyProgress]) {
        self.userJourneyProgress = userJourneyProgress
        collectionView.reloadData()
        setNeedsLayout()
        layoutIfNeeded()
        updateCollectionHeightIfNeeded()
    }

    private func resolveJourney(for index: Int) -> (journey: Invite?, title: String) {
        let userJourney = userJourneyProgress.first
        switch index {
        case 0: return (userJourney?.signUp, "সাইন আপ")
        case 1: return (userJourney?.profileUpdate, "প্রোফাইল")
        default: return (userJourney?.invite, "ইনভাইট")
        }
    }
}

// MARK: - UICollectionViewDataSource
extension HomeFreePointTableViewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { 3 }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FreePointsCollectionViewCell.className,
            for: indexPath
        ) as! FreePointsCollectionViewCell

        let resolved = resolveJourney(for: indexPath.item)

        cell.configure(title: resolved.title, imgURL: resolved.journey?.eventIcon)
        cell.setButtonTitle(.init(point: resolved.journey?.point, isCompleted: resolved.journey?.isCompleted))

        cell.onButtonTap = { [weak self] in
            guard let self else { return }
            self.onJourneyButtonTap?(resolved.journey, indexPath.item)
        }

        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension HomeFreePointTableViewCell: UICollectionViewDelegate { }

final class FreePointsCollectionViewCell: UICollectionViewCell {

    var onButtonTap: (() -> Void)?

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.alignment = .fill
        stackView.distribution = .fill
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
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .center
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()

    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.font(.winFont(.semiBold, size: .medium), title: "খেলুন", color: .white)
        button.backgroundColor = .wcVelvet
        button.applyCornerRadious(12)

        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
        button.titleLabel?.numberOfLines = 1
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.85

        return button
    }()
    
    struct UserJourney {
        let point: Int?
        let isCompleted: Bool?
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupActions()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupView() {
        backgroundColor = .clear
        contentView.backgroundColor = .white
        contentView.applyCornerRadious(16)
        applyShadow()

        contentView.addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(actionButton)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

            // ✅ smaller image so title survives even in compact widths
            imageView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),

            // ✅ guaranteed title area
            titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),

            // ✅ bigger button
            actionButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 32),
            actionButton.widthAnchor.constraint(equalTo: stackView.widthAnchor)
        ])
    }

    private func setupActions() {
        actionButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        titleLabel.text = nil
        onButtonTap = nil
    }

    func configure(title: String, imgURL: String?) {
        titleLabel.text = title
        if let imgURL, imgURL.isNotEmpty { imageView.setImage(from: imgURL) }
    }
    
    func setButtonTitle(_ userJourney: UserJourney?) {
        guard let userJourney,
              let point = userJourney.point,
              let isCompleted = userJourney.isCompleted else { return }

        // ✅ kill any old fallback titles for all states
        actionButton.setTitle(nil, for: .normal)
        actionButton.setTitle(nil, for: .highlighted)
        actionButton.setTitle(nil, for: .selected)
        actionButton.setTitle(nil, for: .disabled)

        let titleText = isCompleted ? "ক্লেইমড" : "+\(point)".toBanglaNumberWithSuffix()

        func makeConfig() -> UIButton.Configuration {
            var config = UIButton.Configuration.filled()

            var attrTitle = AttributedString(titleText)
            attrTitle.font = .winFont(.semiBold, size: .medium)
            config.attributedTitle = attrTitle

            config.baseForegroundColor = .white
            config.baseBackgroundColor = isCompleted ? .systemGray5 : .wcGreen
            config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 12, bottom: 10, trailing: 12)

            if !isCompleted {
                let star = UIImage(resource: .starYellow3D)
                    .withRenderingMode(.alwaysOriginal)
                    .resized(to: CGSize(width: 16, height: 16))
                config.image = star
                config.imagePlacement = .trailing
                config.imagePadding = 6
            }

            return config
        }

        let baseConfig = makeConfig()
        actionButton.configuration = baseConfig
        actionButton.configurationUpdateHandler = { btn in
            btn.configuration = baseConfig
        }
    }
    
    @objc private func didTapButton() { onButtonTap?() }
}

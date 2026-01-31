//
//
//  HomeOnlineGamesTableViewCell.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 18/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//


import UIKit

final class HomeOnlineGamesTableViewCell: UITableViewCell {

    // MARK: - Callbacks
    var onGameTap: ((Int?) -> Void)?

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
        header.setTitle("অনলাইন গেম")
        return header
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = CollectionLayoutFactory.makeLayout([
            .carousel(
                visibleCount: 1.3,
                aspectRatio: 4/3,
                contentInsets: .init(top: 12, leading: 16, bottom: 12, trailing: 16),
                itemSpacing: 12,
                scrolling: .continuous
            )
        ])

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            OnlineGamesCollectionViewCell.self,
            forCellWithReuseIdentifier: OnlineGamesCollectionViewCell.className
        )
        return collectionView
    }()

    private var onlineGames: [OnlineGame] = []

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
        contentView.backgroundColor = .clear

        contentView.addSubview(rootStackView)
        rootStackView.addArrangedSubviews([headerView, collectionView])

        let collectionHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 1)
        collectionHeightConstraint.priority = .defaultHigh
        collectionHeightConstraint.identifier = "collectionViewHeight"

        NSLayoutConstraint.activate([
            rootStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            rootStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            rootStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            rootStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            collectionHeightConstraint
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateCollectionHeightIfNeeded()
    }

    private func updateCollectionHeightIfNeeded() {
        collectionView.layoutIfNeeded()
        let height = collectionView.collectionViewLayout.collectionViewContentSize.height

        if let heightConstraint = collectionView.constraints.first(where: { $0.identifier == "collectionViewHeight" }) {
            if abs(heightConstraint.constant - height) > 1 {
                heightConstraint.constant = height
            }
        }
    }

    // MARK: - Public API
    func configure(_ onlineGames: [OnlineGame]) {
        self.onlineGames = onlineGames
        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
        setNeedsLayout()
        layoutIfNeeded()
        updateCollectionHeightIfNeeded()
    }
}

// MARK: - UICollectionViewDataSource
extension HomeOnlineGamesTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        onlineGames.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: OnlineGamesCollectionViewCell.className,
            for: indexPath
        ) as! OnlineGamesCollectionViewCell
        let game = onlineGames[indexPath.item]
        cell.configure(
            title: game.title ?? "",
            topImageURL: game.gameImage,
            iconImageURL: game.gameIcon
        )
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension HomeOnlineGamesTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let game = onlineGames[indexPath.item]
        onGameTap?(game.onlineGameID)
    }
}

final class OnlineGamesCollectionViewCell: UICollectionViewCell {

    // MARK: - UI
    private let topImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private let centerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.applyCornerRadious(12)
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.font = .winFont(.regular, size: .medium)
        label.textColor = .label
        label.textAlignment = .center
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setupView() {
        contentView.backgroundColor = .white
        contentView.applyCornerRadious(12)
        applyShadow()

        contentView.addSubviews([topImageView, centerImageView, titleLabel])

        NSLayoutConstraint.activate([
            topImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            topImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            topImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            topImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.55),

            centerImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            centerImageView.centerYAnchor.constraint(equalTo: topImageView.bottomAnchor),
            centerImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.28),
            centerImageView.heightAnchor.constraint(equalTo: centerImageView.widthAnchor),

            titleLabel.topAnchor.constraint(equalTo: centerImageView.bottomAnchor, constant: 6),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }

    // MARK: - Public API
    func configure(title: String, topImageURL: String?, iconImageURL: String?) {
        titleLabel.text = title

        if let topImageURL, topImageURL.isNotEmpty {
            topImageView.setImage(from: topImageURL)
        } else {
            topImageView.image = nil
        }

        if let iconImageURL, iconImageURL.isNotEmpty {
            centerImageView.setImage(from: iconImageURL)
        } else {
            centerImageView.image = nil
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        topImageView.image = nil
        centerImageView.image = nil
        titleLabel.text = nil
    }
}

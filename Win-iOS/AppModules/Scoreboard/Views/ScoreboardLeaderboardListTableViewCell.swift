//
//
//  ScoreboardLeaderboardListTableViewCell.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 30/11/25.
//  Contact me if anything is needed:
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

class ScoreboardLeaderboardListTableViewCell: UITableViewCell {

    private var tableHeightConstraint: NSLayoutConstraint?
    private var contentSizeObservation: NSKeyValueObservation?

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.sectionHeaderTopPadding = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.sectionHeaderHeight = CGFloat.leastNonzeroMagnitude
        tableView.sectionFooterHeight = CGFloat.leastNonzeroMagnitude
        tableView.isScrollEnabled = false
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .wcBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(
            ScoreboardLeaderboardTableViewCell.self,
            forCellReuseIdentifier: ScoreboardLeaderboardTableViewCell.className
        )
        return tableView
    }()

    private var leaderboardItemsList: [LeaderboardItem] = []

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        contentSizeObservation?.invalidate()
    }

    // MARK: - Setup
    private func setupView() {
        backgroundColor = .wcBackground
        contentView.addSubview(tableView)
        setupLayout()

        // Single source of truth for inner table height
        contentSizeObservation = tableView.observe(\.contentSize, options: [.new]) { [weak self] tableView, _ in
            guard let self = self else { return }
            self.tableHeightConstraint?.constant = tableView.contentSize.height
        }
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: contentView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

        // IMPORTANT: make this NON-required so it doesn't fight UIView-Encapsulated-Layout-Height
        let heightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)
        heightConstraint.priority = .defaultHigh   // 750 < 1000
        heightConstraint.isActive = true
        self.tableHeightConstraint = heightConstraint
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        leaderboardItemsList = []
        tableView.reloadData()
        tableHeightConstraint?.constant = 0
    }

    // MARK: - Public API
    func configure(_ items: [LeaderboardItem]) {
        self.leaderboardItemsList = items
        
        tableView.reloadData()

        // Do NOT call layoutIfNeeded() on tableView before it’s in window – that caused your other warning.
        // The KVO on contentSize will update height when layout actually happens.
    }
}

// MARK: - UITableViewDataSource
extension ScoreboardLeaderboardListTableViewCell: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return leaderboardItemsList.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ScoreboardLeaderboardTableViewCell.className,
            for: indexPath
        ) as! ScoreboardLeaderboardTableViewCell

        let item = leaderboardItemsList[indexPath.section]
        cell.configure(with: item)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ScoreboardLeaderboardListTableViewCell: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
}


class ScoreboardLeaderboardTableViewCell: UITableViewCell {
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let indexLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .winFont(.semiBold, size: .small)
        label.textColor = .wcVelvet
        label.backgroundColor = .wcVelvet.withAlphaComponent(0.05)
        label.padding = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        label.applyCornerRadious(12, borderWidth: 1, borderColor: .wcVelvet)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.applyCornerRadious(18)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let msisdnLabel: UILabel = {
        let label = UILabel()
        label.font = .winFont(.semiBold, size: .small)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private let slidingLabel: AutoSwipingBadgeView = {
        let slidingView = AutoSwipingBadgeView(
            configuration: .init(
                interval: 3.0,
                animationDuration: 0.35,
                font: .winFont(.semiBold, size: .extraSmall),
                textColor: .wcGreen,
                background: [.wcGreenLight.withAlphaComponent(0.3), .wcBackground],
                horizontalPadding: 12,
                size: CGSize(width: 0, height: 24) // width ignored, height used
            )
        )
        slidingView.translatesAutoresizingMaskIntoConstraints = false
        slidingView.setContentHuggingPriority(.required, for: .horizontal)
        slidingView.setContentCompressionResistancePriority(.required, for: .horizontal)
        return slidingView
    }()

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
        contentView.backgroundColor = .white
        contentView.applyCornerRadious(8)
        contentView.applyShadow()
        
        contentView.addSubview(stackView)
        
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        spacer.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        stackView.addArrangedSubviews([
            indexLabel,
            avatarImageView,
            msisdnLabel,
            spacer,
            slidingLabel
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            indexLabel.widthAnchor.constraint(equalToConstant: 36),
            
            avatarImageView.widthAnchor.constraint(equalToConstant: 36),
            avatarImageView.heightAnchor.constraint(equalToConstant: 36),
            
            slidingLabel.widthAnchor.constraint(equalToConstant: 100),
            slidingLabel.heightAnchor.constraint(equalToConstant: 24),
        ])
    }
    
    // MARK: - Configure
    func configure(with item: LeaderboardItem) {
        indexLabel.text = "\((item.userRank ?? 0).toBanglaNumberWithSuffix())"
        avatarImageView.setImage(from: item.userAvatar ?? "")
        msisdnLabel.text = item.msisdn?.toBanglaNumberWithSuffix().dropLeading88()
        
        if let slider = item.totalRedeemAmount, slider > 0 {
            slidingLabel.isHidden = false
            slidingLabel.setItems([
                "রিডিমড",
                "৳\((slider).toBanglaNumberWithSuffix())"
            ])
        } else {
            slidingLabel.isHidden = true
        }
    }
}

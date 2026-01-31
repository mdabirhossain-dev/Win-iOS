//
//
//  HomeTopThreeTableViewCell.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 15/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//


import UIKit

protocol HomeTopThreeTableViewCellDelegate: AnyObject {
    func containerCell(_ cell: HomeTopThreeTableViewCell, didSelect campaignID: Int)
    func containerCellDidTapSwitchTab(_ cell: HomeTopThreeTableViewCell)
}

final class HomeTopThreeTableViewCell: UITableViewCell {

    enum Section: Int, CaseIterable {
        case campaigns = 0
        case topThree  = 1
        case switchTab = 2
    }

    weak var delegate: HomeTopThreeTableViewCellDelegate?

    private var campaigns: [Campaign] = []
    private var topThree: [LeaderboardItem] = []

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
        let headerView = SectionHeaderView()
        headerView.setTitle("সেরা ৩ জন বিজয়ী")
        return headerView
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self

        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.sectionHeaderTopPadding = 0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        tableView.isScrollEnabled = false
        tableView.contentInset = .zero
        tableView.applyCornerRadious(16)
        tableView.applyShadow()

        tableView.register(
            ScoreboardCampaignsTableViewCell.self,
            forCellReuseIdentifier: ScoreboardCampaignsTableViewCell.className
        )
        tableView.register(
            ScoreboardTopThreeTableViewCell.self,
            forCellReuseIdentifier: ScoreboardTopThreeTableViewCell.className
        )
        tableView.register(
            ScoreboardSwitchTabButtonTableViewCell.self,
            forCellReuseIdentifier: ScoreboardSwitchTabButtonTableViewCell.className
        )

        return tableView
    }()

    private lazy var tableHeightConstraint: NSLayoutConstraint = {
        let constraint = tableView.heightAnchor.constraint(equalToConstant: 1)
        constraint.priority = .required
        return constraint
    }()

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
        rootStackView.addArrangedSubviews([headerView, tableView])

        NSLayoutConstraint.activate([
            rootStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            rootStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            rootStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            rootStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            tableHeightConstraint
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        tableView.layoutIfNeeded()
        let h = tableView.contentSize.height
        if tableHeightConstraint.constant != h {
            tableHeightConstraint.constant = h
        }

        tableView.layer.shadowPath = UIBezierPath(
            roundedRect: tableView.bounds,
            cornerRadius: 16
        ).cgPath
    }

    // MARK: - Public API
    func configure(
        campaigns: [Campaign],
        topThree: [LeaderboardItem]
    ) {
        self.campaigns = campaigns
        self.topThree = topThree

        tableView.reloadData()

        setNeedsLayout()
        layoutIfNeeded()
    }

    func updateTopThree(_ items: [LeaderboardItem]) {
        topThree = items
        tableView.reloadSections(IndexSet(integer: Section.topThree.rawValue), with: .fade)

        setNeedsLayout()
        layoutIfNeeded()
    }
}

// MARK: - UITableViewDataSource
extension HomeTopThreeTableViewCell: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        Section.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let section = Section(rawValue: indexPath.section) else {
            return UITableViewCell()
        }

        switch section {
        case .campaigns:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ScoreboardCampaignsTableViewCell.className,
                for: indexPath
            ) as! ScoreboardCampaignsTableViewCell

            cell.delegate = self
            cell.configure(campaigns)
            return cell

        case .topThree:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ScoreboardTopThreeTableViewCell.className,
                for: indexPath
            ) as! ScoreboardTopThreeTableViewCell

            cell.configure(topThree)
            return cell

        case .switchTab:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ScoreboardSwitchTabButtonTableViewCell.className,
                for: indexPath
            ) as! ScoreboardSwitchTabButtonTableViewCell

            cell.delegate = self
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension HomeTopThreeTableViewCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { 0 }
}

// MARK: - Forward campaign selection up
extension HomeTopThreeTableViewCell: ScoreboardCampaignsTableViewCellDelegate {
    func campaignsCell(_ cell: ScoreboardCampaignsTableViewCell, didSelect campaignID: Int) {
        delegate?.containerCell(self, didSelect: campaignID)
    }
}

// MARK: - Forward switch tab tap up
extension HomeTopThreeTableViewCell: HomeSwitchToScoreboardButtonCellDelegate {
    func switchTabButtonCellDidTap(_ cell: ScoreboardSwitchTabButtonTableViewCell) {
        delegate?.containerCellDidTapSwitchTab(self)
    }
}

protocol HomeSwitchToScoreboardButtonCellDelegate: AnyObject {
    func switchTabButtonCellDidTap(_ cell: ScoreboardSwitchTabButtonTableViewCell)
}

final class ScoreboardSwitchTabButtonTableViewCell: UITableViewCell {

    weak var delegate: HomeSwitchToScoreboardButtonCellDelegate?

    private let actionButton: WinButton = {
        let button = WinButton(textColor: .wcVelvet)
        button.font(.winFont(.semiBold, size: .medium), title: "সম্পূর্ণ তালিকা", color: .wcVelvet)
        button.applyCornerRadious(22, borderWidth: 1, borderColor: .wcVelvet)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupView() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        contentView.addSubview(actionButton)

        NSLayoutConstraint.activate([
            actionButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            actionButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            actionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            actionButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            actionButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 44)
        ])

        actionButton.addTarget(self, action: #selector(didTap), for: .touchUpInside)
    }

    @objc private func didTap() {
        delegate?.switchTabButtonCellDidTap(self)
    }
}

//
//
//  ScoreboardViewController.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 21/10/25.
//  Contact me if anything is needed:
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

final class ScoreboardViewController: UIViewController {

    var presenter: ScoreboardPresenterProtocol?

    // MARK: - UI
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .wcBackground
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.sectionHeaderTopPadding = 0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(ScoreboardCampaignsTableViewCell.self, forCellReuseIdentifier: ScoreboardCampaignsTableViewCell.className)
        tableView.register(ScoreboardTopThreeTableViewCell.self, forCellReuseIdentifier: ScoreboardTopThreeTableViewCell.className)
        tableView.register(ScoreboardLeaderboardListTableViewCell.self, forCellReuseIdentifier: ScoreboardLeaderboardListTableViewCell.className)
        tableView.register(ScoreboardMyPositionTableViewCell.self, forCellReuseIdentifier: ScoreboardMyPositionTableViewCell.className)
        tableView.register(ScoreboardRedemptionWinnersTableViewCell.self, forCellReuseIdentifier: ScoreboardRedemptionWinnersTableViewCell.className)

        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNonzeroMagnitude))
        return tableView
    }()

    // Simple local loader (compiles). Replace with your existing Loader if you have one.
    private let loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.hidesWhenStopped = true
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        assert(presenter != nil, "You MUST open this VC via ScoreboardRouter.createModule()")

        setupView()
        presenter?.viewDidLoad()
    }

    private func setupView() {
        viewControllerTitle = "স্কোরবোর্ড"
        setupNavigationBar(isBackButton: true, delegate: self)

        view.backgroundColor = .wcBackground
        view.addSubview(tableView)
        view.addSubview(loadingView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
    }
}

// MARK: - View Protocol
extension ScoreboardViewController: ScoreboardViewProtocol {

    func reload() {
        tableView.reloadData()
    }

    func showError(_ message: String) {
        Toast.show(message, style: .error)
    }

    func setLoading(_ isLoading: Bool) {
        if isLoading {
            loadingView.startAnimating()
        } else {
            loadingView.stopAnimating()
        }
    }
}

// MARK: - UITableViewDataSource
extension ScoreboardViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        presenter?.sections.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let sectionType = presenter?.sections[indexPath.section] else {
            return UITableViewCell()
        }

        switch sectionType {

        case .campaigns:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ScoreboardCampaignsTableViewCell.className,
                for: indexPath
            ) as! ScoreboardCampaignsTableViewCell
            cell.delegate = self
            cell.configure(presenter?.campaigns() ?? [])
            return cell

        case .topThree:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ScoreboardTopThreeTableViewCell.className,
                for: indexPath
            ) as! ScoreboardTopThreeTableViewCell
            cell.configure(presenter?.topThree() ?? [])
            return cell

        case .leaderboard:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ScoreboardLeaderboardListTableViewCell.className,
                for: indexPath
            ) as! ScoreboardLeaderboardListTableViewCell
            cell.configure(presenter?.leaderboard() ?? [])
            return cell

        case .myPosition:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ScoreboardMyPositionTableViewCell.className,
                for: indexPath
            ) as! ScoreboardMyPositionTableViewCell
            cell.configure(presenter?.myPosition())
            return cell

        case .redemptionWinners:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ScoreboardRedemptionWinnersTableViewCell.className,
                for: indexPath
            ) as! ScoreboardRedemptionWinnersTableViewCell

            if let data = presenter?.redemption() {
                cell.configure(data)
            }
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension ScoreboardViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { 10 }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView()
        v.backgroundColor = .clear
        return v
    }
}

// MARK: - Campaigns delegate
extension ScoreboardViewController: ScoreboardCampaignsTableViewCellDelegate {
    func campaignsCell(_ cell: ScoreboardCampaignsTableViewCell, didSelect campaignID: Int) {
        presenter?.didSelectCampaign(id: campaignID)
    }
}

// MARK: - Back behavior (same as your old code, via router)
extension ScoreboardViewController: NavigationBarDelegate {
    func navBarDidTapBack(in vc: UIViewController) {
        presenter?.didTapBack()
    }
}

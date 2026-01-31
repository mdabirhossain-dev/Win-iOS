//
//
//  HomeViewController.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 15/10/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

final class HomeViewController: UIViewController {

    var presenter: HomePresenterProtocol?

    // MARK: - UI Properties
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .wcBackground
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.sectionHeaderTopPadding = 0
        tableView.rowHeight = UITableView.automaticDimension

        tableView.separatorInset = .zero
        tableView.layoutMargins = .zero
        tableView.directionalLayoutMargins = .zero
        tableView.cellLayoutMarginsFollowReadableWidth = false
        if #available(iOS 11.0, *) { tableView.insetsContentViewsToSafeArea = false }

        tableView.register(HomeBillboardsTableViewCell.self, forCellReuseIdentifier: HomeBillboardsTableViewCell.className)
        tableView.register(HomePromoCardTableViewCell.self, forCellReuseIdentifier: HomePromoCardTableViewCell.className)
        tableView.register(HomeBannerTableViewCell.self, forCellReuseIdentifier: HomeBannerTableViewCell.className)
        tableView.register(ScoreboardRedemptionWinnersTableViewCell.self, forCellReuseIdentifier: ScoreboardRedemptionWinnersTableViewCell.className)
        tableView.register(ScoreboardTopThreeTableViewCell.self, forCellReuseIdentifier: ScoreboardTopThreeTableViewCell.className)
        tableView.register(HomeTopThreeTableViewCell.self, forCellReuseIdentifier: HomeTopThreeTableViewCell.className)
        tableView.register(HomeLudoMasterTableViewCell.self, forCellReuseIdentifier: HomeLudoMasterTableViewCell.className)
        tableView.register(HomeQuizCategoryTableViewCell.self, forCellReuseIdentifier: HomeQuizCategoryTableViewCell.className)
        tableView.register(HomeFeaturesTableViewCell.self, forCellReuseIdentifier: HomeFeaturesTableViewCell.className)
        tableView.register(HomePointTransferTableViewCell.self, forCellReuseIdentifier: HomePointTransferTableViewCell.className)
        tableView.register(HomeFreePointTableViewCell.self, forCellReuseIdentifier: HomeFreePointTableViewCell.className)
        tableView.register(HomeTicTacToeTableViewCell.self, forCellReuseIdentifier: HomeTicTacToeTableViewCell.className)
        tableView.register(HomeOnlineGamesTableViewCell.self, forCellReuseIdentifier: HomeOnlineGamesTableViewCell.className)
        tableView.register(HomeWatchLiveTableViewCell.self, forCellReuseIdentifier: HomeWatchLiveTableViewCell.className)
        tableView.register(HomeLakhopotiCountdownTableViewCell.self, forCellReuseIdentifier: HomeLakhopotiCountdownTableViewCell.className)

        return tableView
    }()

    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabbarVisibility(.show)
        presenter?.viewDidLoad()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        assert(presenter != nil, "Open via HomeRouter.createModule()")
        setupView()
    }

    // MARK: - Setup
    private func setupView() {
        let storeButton = [
            NavigationBarButtonConfig(
                title: "স্টোর",
                image: UIImage(resource: .premiumCrownGradient),
                renderingMode: .alwaysOriginal
            )
        ]
        setupNavigationBar(
            projectIcon: (UIImage(resource: .winLogoText), .alwaysOriginal),
            rightButtons: storeButton,
            isBackButton: false,
            delegate: self
        )

        view.backgroundColor = .wcBackground
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
    }
}

// MARK: - NavigationBarDelegate
extension HomeViewController: NavigationBarDelegate {
    func navBar(_ vc: UIViewController, didTapRightButtonAt index: Int) {
        if index == 0 { presenter?.didTapStore() }
    }
}

// MARK: - HomeViewProtocol
extension HomeViewController: HomeViewProtocol {

    func setLoading(_ isLoading: Bool) {
        showLoader(isLoading ? .loading : .hidden)
    }

    func reloadTableView() {
        tableView.reloadData()
    }

    func showToast(message: String, isError: Bool) {
        Toast.show(message, style: isError ? .error : .success)
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int { 16 }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { 16 }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let spacer = UIView()
        spacer.backgroundColor = .clear
        return spacer
    }
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let homeContents = presenter?.homeContents
        let redemptionLeaderboard = presenter?.redemptionLeaderboard
        let campaigns = presenter?.campaignsWithLeaderboards

        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeBillboardsTableViewCell.className, for: indexPath) as! HomeBillboardsTableViewCell
            cell.configure(billboards: homeContents?.billboards)
            return cell

        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: HomePromoCardTableViewCell.className, for: indexPath) as! HomePromoCardTableViewCell
            let happyHour = homeContents?.happyHours?.first
            let title = happyHour?.title ?? ""
            // ✅ Stop showing "duration" if it’s wrong.
            cell.configure(title: title, subtitle: "হ্যাপি আওয়ার চলছে", imgURL: happyHour?.happyHourImage)
            return cell

        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeTicTacToeTableViewCell.className, for: indexPath) as! HomeTicTacToeTableViewCell
            let filtered: [TicTacToeData] = homeContents?.ticTacToeData?
                .filter { id in
                    guard let v = id.id else { return false }
                    return v == 1 || v == 2 || v == 3
                } ?? []
            cell.configure(filtered)
            return cell

        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeLudoMasterTableViewCell.className, for: indexPath) as! HomeLudoMasterTableViewCell
            if let ludoData = homeContents?.ludoData {
                cell.configure(ludoData)
            }
            return cell

        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeBannerTableViewCell.className, for: indexPath) as! HomeBannerTableViewCell
            let banner = homeContents?.banners?.first
            cell.configure(title: banner?.bannerTitle ?? "", subtitle: banner?.subTitle ?? "", imgURL: banner?.bannerImage)
            return cell

        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: HomePointTransferTableViewCell.className, for: indexPath) as! HomePointTransferTableViewCell
            if let items = homeContents?.pointTransferDetails { cell.configure(items) }
            cell.delegate = self
            return cell

        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeLakhopotiCountdownTableViewCell.className, for: indexPath) as! HomeLakhopotiCountdownTableViewCell
            cell.configure(homeContents?.lakhopotis?.first)
            return cell

        case 7:
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeWatchLiveTableViewCell.className, for: indexPath) as! HomeWatchLiveTableViewCell
            cell.configure(homeContents?.lakhopotis?.first?.title ?? "")
            return cell

        case 8:
            let cell = tableView.dequeueReusableCell(withIdentifier: ScoreboardRedemptionWinnersTableViewCell.className, for: indexPath) as! ScoreboardRedemptionWinnersTableViewCell
            cell.configure(redemptionLeaderboard)
            return cell

        case 9:
            let cell = tableView.dequeueReusableCell(withIdentifier: HomePromoCardTableViewCell.className, for: indexPath) as! HomePromoCardTableViewCell
            let watchAndWin = homeContents?.watchAndWin?.first
            cell.configure(title: watchAndWin?.title ?? "", subtitle: "ভিডিও কুইজ খেলে স্কোর করুন", imgURL: watchAndWin?.imageSource)
            return cell

        case 10:
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeFeaturesTableViewCell.className, for: indexPath) as! HomeFeaturesTableViewCell
            if let features = homeContents?.features { cell.configure(features: features) }
            return cell

        case 11:
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeQuizCategoryTableViewCell.className, for: indexPath) as! HomeQuizCategoryTableViewCell
            if let quiz = homeContents?.quizCategories { cell.configure(quiz) }
            return cell

        case 12:
            let cell = tableView.dequeueReusableCell(withIdentifier: HomePromoCardTableViewCell.className, for: indexPath) as! HomePromoCardTableViewCell
            let daily = homeContents?.dailyCheckIn?.first
            cell.configure(title: daily?.featureTitle ?? "", subtitle: "প্রতিদিন ফ্রি পয়েন্ট অর্জন করুন", imgURL: daily?.featureImage)
            return cell

        case 13:
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeFreePointTableViewCell.className, for: indexPath) as! HomeFreePointTableViewCell
            if let journey = homeContents?.userJourneyProgress { cell.configure(journey) }
            cell.onJourneyButtonTap = { [weak self] journey, index in
                self?.presenter?.didTapJourney(journey: journey, index: index)
            }
            return cell

        case 14:
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeOnlineGamesTableViewCell.className, for: indexPath) as! HomeOnlineGamesTableViewCell
            let games = homeContents?.onlineGames ?? []
            cell.configure(games)
            cell.onGameTap = { [weak self] gameID in
                guard let id = gameID else { return }
                self?.presenter?.didTapOnlineGame(id)
            }
            return cell

        case 15:
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeTopThreeTableViewCell.className, for: indexPath) as! HomeTopThreeTableViewCell
            cell.configure(
                campaigns: campaigns ?? [],
                topThree: campaigns?.first?.leaderboardItemsList ?? []
            )
            cell.delegate = self
            return cell

        default:
            return UITableViewCell()
        }
    }
}

// MARK: - Delegates
extension HomeViewController: HomePointTransferTableViewCellDelegate {

    func pointTransferCell(_ cell: HomePointTransferTableViewCell, didTapButtonAt index: Int, item: PointTransferDetail) {
        presenter?.didTapPointTransfer(item: item)
    }

    func pointTransferCell(_ cell: HomePointTransferTableViewCell, didSelectItemAt index: Int, item: PointTransferDetail) {
        presenter?.didTapPointTransfer(item: item)
    }
}

extension HomeViewController: HomeTopThreeTableViewCellDelegate {
    func containerCell(_ cell: HomeTopThreeTableViewCell, didSelect campaignID: Int) { }
    func containerCellDidTapSwitchTab(_ cell: HomeTopThreeTableViewCell) {
        presenter?.didTapSwitchToScoreboard()
    }
}


//final class HomeViewController: UIViewController {
//
//    // MARK: - UI Properties
//    private lazy var tableView: UITableView = {
//        let tableView = UITableView(frame: .zero, style: .plain)
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.backgroundColor = .wcBackground
//        tableView.showsVerticalScrollIndicator = false
//        tableView.separatorStyle = .none
//        tableView.allowsSelection = false
//        tableView.sectionHeaderTopPadding = 0
//        tableView.rowHeight = UITableView.automaticDimension
////         tv.estimatedRowHeight = 320
//
//        // Make headers/cells able to go edge-to-edge
//        tableView.separatorInset = .zero
//        tableView.layoutMargins = .zero
//        tableView.directionalLayoutMargins = .zero
//        tableView.cellLayoutMarginsFollowReadableWidth = false
//        if #available(iOS 11.0, *) {
//            tableView.insetsContentViewsToSafeArea = false
//        }
//        tableView.register(
//            HomeBillboardsTableViewCell.self,
//            forCellReuseIdentifier:  HomeBillboardsTableViewCell.className
//        )
//        tableView.register(
//            HomePromoCardTableViewCell.self,
//            forCellReuseIdentifier: HomePromoCardTableViewCell.className
//        )
//        tableView.register(
//            HomeBannerTableViewCell.self,
//            forCellReuseIdentifier: HomeBannerTableViewCell.className
//        )
//        tableView.register(
//            ScoreboardRedemptionWinnersTableViewCell.self,
//            forCellReuseIdentifier: ScoreboardRedemptionWinnersTableViewCell.className
//        )
//        tableView.register(
//            ScoreboardTopThreeTableViewCell.self,
//            forCellReuseIdentifier: ScoreboardTopThreeTableViewCell.className
//        )
//        tableView.register(
//            HomeTopThreeTableViewCell.self,
//            forCellReuseIdentifier: HomeTopThreeTableViewCell.className
//        )
//        tableView.register(
//            HomeLudoMasterTableViewCell.self,
//            forCellReuseIdentifier: HomeLudoMasterTableViewCell.className
//        )
//        tableView.register(
//            HomeQuizCategoryTableViewCell.self,
//            forCellReuseIdentifier: HomeQuizCategoryTableViewCell.className
//        )
//        tableView.register(
//            HomeFeaturesTableViewCell.self,
//            forCellReuseIdentifier: HomeFeaturesTableViewCell.className
//        )
//        tableView.register(
//            HomePointTransferTableViewCell.self,
//            forCellReuseIdentifier: HomePointTransferTableViewCell.className
//        )
//        tableView.register(
//            HomeFreePointTableViewCell.self,
//            forCellReuseIdentifier: HomeFreePointTableViewCell.className
//        )
//        tableView.register(
//            HomeTicTacToeTableViewCell.self,
//            forCellReuseIdentifier: HomeTicTacToeTableViewCell.className
//        )
//        tableView.register(
//            HomeOnlineGamesTableViewCell.self,
//            forCellReuseIdentifier: HomeOnlineGamesTableViewCell.className
//        )
//        tableView.register(
//            HomeWatchLiveTableViewCell.self,
//            forCellReuseIdentifier: HomeWatchLiveTableViewCell.className
//        )
//        tableView.register(
//            HomeLakhopotiCountdownTableViewCell.self,
//            forCellReuseIdentifier: HomeLakhopotiCountdownTableViewCell.className
//        )
//        return tableView
//    }()
//    
//    private let viewModel = HomeViewModel()
//
//    // MARK: - Lifecycle
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        tabbarVisibility(.show)
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupView()
//        viewModel.fetchHomeContents()
//        viewModel.fetchRedemptionLeaderboard()
//        viewModel.fetchCampaignsWithLeaderboards()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//            self.tableView.reloadData()
//        }
//    }
//
//    // MARK: - Setup
//    private func setupView() {
//        let storeButton = [
//            NavigationBarButtonConfig(
//                title: "স্টোর",
//                image: UIImage(resource: .premiumCrownGradient),
//                renderingMode: .alwaysOriginal
//            )
//        ]
//        setupNavigationBar(
//            projectIcon: (UIImage(resource: .winLogoText), .alwaysOriginal),
//            rightButtons: storeButton,
//            isBackButton: false,
//            delegate: self
//        )
//
//        view.backgroundColor = .wcBackground
//        view.addSubview(tableView)
//
//        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
//            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
//            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
//        ])
//        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
//    }
//    
//    private func switchToScoreboardTab() {
//        guard let tabBar = tabBarController as? TabbarContoller else {
//            navigationController?.popViewController(animated: true)
//            return
//        }
//        tabBar.chanageTabbar(for: 0)
//    }
//    
//    private func handleJourneyTap(journey: Invite?, index: Int) {
//        guard !(journey?.isCompleted ?? true) else { return }
//        switch index {
//        case 0:
//            navigationController?.pushViewController(.signUp)
//        case 1:
//            navigationController?.pushViewController(.updateProfile(UpdateProfileRequest(fullName: "FULL name", gender: "", userAvatarId: "DD"), avatarUrl: "")) // handle in the Edit profile. If no data or nil data, then call API and update UpdateProfile VC there
//        case 2:
//            navigationController?.pushViewController(.invitation)
//        default:
//            assertionFailure("Unexpected index: \(index)")
//        }
//    }
//}
//
//// MARK: - NavigationBarDelegate
//extension HomeViewController: NavigationBarDelegate {
//    func navBar(_ vc: UIViewController, didTapRightButtonAt index: Int) {
//        switch index {
//        case 0:
//            navigationController?.pushViewController(.store)
//            Log.info("Navigate to STORE")
//        default:
//            break
//        }
//    }
//}
//
//// MARK: - UITableViewDelegate
//extension HomeViewController: UITableViewDelegate {
//
//    func numberOfSections(in tableView: UITableView) -> Int { 16 }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        switch section {
////        case 2: return 52
//        default: return 16
//        }
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        switch section {
//        case 2:
//            let header = SectionHeaderView()
//
//            // ✅ Make sure header itself doesn’t preserve margins from parent
//            header.preservesSuperviewLayoutMargins = false
//            header.layoutMargins = .zero
//            header.setTitle("Happy Hour")
//            header.showsSeeAll = true
//            header.onTapSeeAll = { [weak self] in
//                // navigate
//                _ = self
//            }
//            return UIView()
//
//        default:
//            let spacer = UIView()
//            spacer.backgroundColor = .clear
//            return spacer
//        }
//    }
//}
//
//// MARK: - UITableViewDataSource
//extension HomeViewController: UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        switch indexPath.section {
//        case 0:
//            let cell = tableView.dequeueReusableCell(
//                withIdentifier:  HomeBillboardsTableViewCell.className,
//                for: indexPath
//            ) as! HomeBillboardsTableViewCell
//            guard let billboard = viewModel.homeContents?.billboards else {
//                cell.configure(billboards: nil)
//                return cell
//            }
//            cell.configure(billboards: billboard)
//            return cell
//        case 1:
//            let cell = tableView.dequeueReusableCell(
//                withIdentifier: HomePromoCardTableViewCell.className,
//                for: indexPath
//            ) as! HomePromoCardTableViewCell
//            guard let happyHour = viewModel.homeContents?.happyHours?[0], let title = happyHour.title, let subTitle = happyHour.bengaliDuration else {
//                cell.configure(title: "", subtitle: "", imgURL: nil)
//                return cell
//            }
//            cell.configure(title: title, subtitle: subTitle, imgURL: happyHour.happyHourImage)
//            return cell
//        case 2:
//            let cell = tableView.dequeueReusableCell(
//                withIdentifier: HomeTicTacToeTableViewCell.className,
//                for: indexPath
//            ) as! HomeTicTacToeTableViewCell
//            let filtered: [TicTacToeData] = viewModel.homeContents?.ticTacToeData?
//                .filter { item in
//                    guard let id = item.id else { return false }
//                    return id == 1 || id == 2 || id == 3
//                } ?? []
//            cell.configure(filtered)
//            return cell
//        case 3:
//            let cell = tableView.dequeueReusableCell(
//                withIdentifier: HomeLudoMasterTableViewCell.className,
//                for: indexPath
//            ) as! HomeLudoMasterTableViewCell
//            if let ludoData = viewModel.homeContents?.ludoData {
//                cell.configure(viewModel.homeContents?.ludoData ?? ludoData)
//            }
//            return cell
//        case 4:
//            let cell = tableView.dequeueReusableCell(
//                withIdentifier: HomeBannerTableViewCell.className,
//                for: indexPath
//            ) as! HomeBannerTableViewCell
//            guard let banner = viewModel.homeContents?.banners?[0], let title = banner.bannerTitle, let subTitle = banner.subTitle else {
//                cell.configure(title: "", subtitle: "", imgURL: nil)
//                return cell
//            }
//            cell.configure(title: title, subtitle: subTitle, imgURL: banner.bannerImage)
//            return cell
//        case 5:
//            let cell = tableView.dequeueReusableCell(
//                withIdentifier: HomePointTransferTableViewCell.className,
//                for: indexPath
//            ) as! HomePointTransferTableViewCell
//            if let pointTransferDetails = viewModel.homeContents?.pointTransferDetails {
//                cell.configure(pointTransferDetails)
//            }
//            cell.delegate = self
//            return cell
//        case 6:
//            let cell = tableView.dequeueReusableCell(
//                withIdentifier: HomeLakhopotiCountdownTableViewCell.className,
//                for: indexPath
//            ) as! HomeLakhopotiCountdownTableViewCell
//            let lakhopoti = viewModel.homeContents?.lakhopotis?[0]
//            cell.configure(lakhopoti)
//            return cell
//        case 7:
//            let cell = tableView.dequeueReusableCell(
//                withIdentifier: HomeWatchLiveTableViewCell.className,
//                for: indexPath
//            ) as! HomeWatchLiveTableViewCell
//            let title = viewModel.homeContents?.lakhopotis?[0].title ?? ""
//            cell.configure(title)
//            return cell
//        case 8:
//            let cell = tableView.dequeueReusableCell(
//                withIdentifier: ScoreboardRedemptionWinnersTableViewCell.className,
//                for: indexPath
//            ) as! ScoreboardRedemptionWinnersTableViewCell
//            guard let redemptionLeaderboard = viewModel.redemptionLeaderboard else {
//                cell.configure(nil)
//                return cell
//            }
//            cell.configure(redemptionLeaderboard)
//            return cell
//        case 9:
//            let cell = tableView.dequeueReusableCell(
//                withIdentifier: HomePromoCardTableViewCell.className,
//                for: indexPath
//            ) as! HomePromoCardTableViewCell
//            guard let watchAndWin = viewModel.homeContents?.watchAndWin?[0], let title = watchAndWin.title else {
//                cell.configure(title: "", subtitle: "", imgURL: nil)
//                return cell
//            }
//            cell.configure(title: title, subtitle: "ভিডিও কুইজ খেলে স্কোর করুন", imgURL: watchAndWin.imageSource)
//            return cell
//        case 10:
//            let cell = tableView.dequeueReusableCell(
//                withIdentifier: HomeFeaturesTableViewCell.className,
//                for: indexPath
//            ) as! HomeFeaturesTableViewCell
//            if let features = viewModel.homeContents?.features {
//                cell.configure(features: features)
//            }
//            return cell
//        case 11:
//            let cell = tableView.dequeueReusableCell(
//                withIdentifier: HomeQuizCategoryTableViewCell.className,
//                for: indexPath
//            ) as! HomeQuizCategoryTableViewCell
//            if let quiz = viewModel.homeContents?.quizCategories {
//                cell.configure(quiz)
//            }
//            return cell
//        case 12:
//            let cell = tableView.dequeueReusableCell(
//                withIdentifier: HomePromoCardTableViewCell.className,
//                for: indexPath
//            ) as! HomePromoCardTableViewCell
//            guard let dailyCheckin = viewModel.homeContents?.dailyCheckIn?[0], let title = dailyCheckin.featureTitle else {
//                cell.configure(title: "", subtitle: "", imgURL: nil)
//                return cell
//            }
//            cell.configure(title: title, subtitle: "প্রতিদিন ফ্রি পয়েন্ট অর্জন করুন", imgURL: dailyCheckin.featureImage)
//            return cell
//        case 13:
////            let cell = tableView.dequeueReusableCell(
////                withIdentifier: HomeFreePointTableViewCell.className,
////                for: indexPath
////            ) as! HomeFreePointTableViewCell
////            if let userJourney = viewModel.homeContents?.userJourneyProgress {
////                cell.configure(userJourney)
////            }
////            return cell
//            let cell = tableView.dequeueReusableCell(
//                withIdentifier: HomeFreePointTableViewCell.className,
//                for: indexPath
//            ) as! HomeFreePointTableViewCell
//            
//            if let userJourney = viewModel.homeContents?.userJourneyProgress {
//                cell.configure(userJourney)
//            }
//            
//            cell.onJourneyButtonTap = { [weak self] journey, index in
//                guard let self else { return }
//                self.handleJourneyTap(journey: journey, index: index)
//            }
//            
//            return cell
//        case 14:
//            let cell = tableView.dequeueReusableCell(
//                withIdentifier: HomeOnlineGamesTableViewCell.className,
//                for: indexPath
//            ) as! HomeOnlineGamesTableViewCell
//            let filtered: [OnlineGame] = viewModel.homeContents?.onlineGames ?? []
//            cell.configure(filtered)
//            cell.onGameTap = { [weak self] gameID in
//                guard let self, let gameID else { return }
//                navigationController?.pushViewController(.onlineGames(gameID))
//            }
//            return cell
//        case 15:
//            let cell = tableView.dequeueReusableCell(
//                withIdentifier: HomeTopThreeTableViewCell.className,
//                for: indexPath
//            ) as! HomeTopThreeTableViewCell
//            cell.configure(campaigns: viewModel.campaignsWithLeaderboards ?? [], topThree: viewModel.campaignsWithLeaderboards?[0].leaderboardItemsList ?? [])
//            cell.delegate = self
//            return cell
//        default:
//            return UITableViewCell()
//        }
//    }
//}
//
//extension HomeViewController: HomePointTransferTableViewCellDelegate {
//
//    func pointTransferCell(_ cell: HomePointTransferTableViewCell, didTapButtonAt index: Int, item: PointTransferDetail) {
//        // ✅ Navigate from here
//        routeToPointTransfer(item)
//    }
//
//    func pointTransferCell(_ cell: HomePointTransferTableViewCell, didSelectItemAt index: Int, item: PointTransferDetail) {
//        // optional: if selecting the tile should also navigate
//        routeToPointTransfer(item)
//    }
//
//    private func routeToPointTransfer(_ item: PointTransferDetail) {
//        // Example routing – replace with your actual navigation
//        // navigationController?.pushViewController(vc, animated: true)
//        switch item.id {
//        case 1:
//            navigationController?.pushViewController(.giftPoint())
//        case 2:
//            navigationController?.pushViewController(.requestPoint())
//        case .none:
//            break
//        case .some(_):
//            break
//        }
//        print("Navigate using:", item)
//    }
//}
//
//extension HomeViewController: HomeTopThreeTableViewCellDelegate {
//    
//    func containerCell(_ cell: HomeTopThreeTableViewCell, didSelect campaignID: Int) { }
//
//    func containerCellDidTapSwitchTab(_ cell: HomeTopThreeTableViewCell) {
//        switchToScoreboardTab()
//    }
//}
//
//
//// MARK: - SubscriptionHistoryViewProtocol (as you had)
//extension HomeViewController {
//
//    func showLoading() { showLoader(.loading) }
//
//    func hideLoading() { showLoader(.hidden) }
//
//    func reloadTableView() { tableView.reloadData() }
//
//    func showToast(message: String, isError: Bool) {
//        Toast.show(message, style: isError ? .error : .success)
//    }
//}
//
//class HomeViewModel {
//    
//    private(set) var homeContents: HomeContents?
//    private(set) var redemptionLeaderboard: RedemptionLeaderboard?
//    private(set) var campaignsWithLeaderboards: CampaignList?
//    private let networkClient: NetworkClient
//
//    init(networkClient: NetworkClient = NetworkClient()) {
//        self.networkClient = networkClient
//    }
//    
//    func fetchHomeContents() {
//        Task { [weak self] in
//            guard let self else { return }
//
//            var request = APIRequest(path: APIConstants.homeContentURL)
//            request.method = .get
//
//            do {
//                let response: APIResponse<HomeContents> = try await networkClient.get(request)
//                await MainActor.run {
//                    if let data = response.data {
//                        self.homeContents = data
//                        
//                    } else {
//                        
//                    }
//                }
//            } catch {
//                print("HOME API FAILED ❌", error)
//            }
//        }
//    }
//    
//    func fetchRedemptionLeaderboard() {
//        Task { [weak self] in
//            guard let self else { return }
//
//            var request = APIRequest(path: APIConstants.redemptionLeaderboardURL)
//            request.method = .get
//
//            do {
//                let response: APIResponse<RedemptionLeaderboard> = try await networkClient.get(request)
//                await MainActor.run {
//                    if let data = response.data {
//                        self.redemptionLeaderboard = data
//                    } else {
//                        
//                    }
//                }
//            } catch {
//                print("HOME API FAILED ❌", error)
//            }
//        }
//    }
//    
//    func fetchCampaignsWithLeaderboards() {
//        Task { [weak self] in
//            guard let self else { return }
//
//            var request = APIRequest(path: APIConstants.campaignsWithLeaderboardsURL)
//            request.method = .get
//
//            do {
//                let response: APIResponse<CampaignList> = try await networkClient.get(request)
//                await MainActor.run {
//                    if let data = response.data {
//                        self.campaignsWithLeaderboards = data
////                        print(self.campaignsWithLeaderboards)
//                    } else {
//                        
//                    }
//                }
//            } catch {
//                print("HOME API FAILED ❌", error)
//            }
//        }
//    }
//}

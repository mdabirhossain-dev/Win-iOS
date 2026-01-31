//
//
//  HomeProtocols.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 25/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//


import UIKit

protocol HomeViewProtocol: AnyObject {
    func setLoading(_ isLoading: Bool)
    func reloadTableView()
    func showToast(message: String, isError: Bool)
}

protocol HomePresenterProtocol: AnyObject {
    var homeContents: HomeContents? { get }
    var redemptionLeaderboard: RedemptionLeaderboard? { get }
    var campaignsWithLeaderboards: CampaignList? { get }

    func viewDidLoad()
    func didTapStore()
    func didTapSwitchToScoreboard()
    func didTapOnlineGame(_ gameID: Int)
    func didTapJourney(journey: Invite?, index: Int)

    func didTapPointTransfer(item: PointTransferDetail)
}

protocol HomeInteractorProtocol: AnyObject {
    func fetchHomeContents()
    func fetchRedemptionLeaderboard()
    func fetchCampaignsWithLeaderboards()
}

protocol HomeInteractorOutput: AnyObject {
    func homeContentsFetched(_ contents: HomeContents)
    func homeContentsFailed(_ message: String)

    func redemptionLeaderboardFetched(_ data: RedemptionLeaderboard)
    func redemptionLeaderboardFailed(_ message: String)

    func campaignsWithLeaderboardsFetched(_ data: CampaignList)
    func campaignsWithLeaderboardsFailed(_ message: String)
}

protocol HomeRouterProtocol: AnyObject {
    static func createModule() -> UIViewController

    func goToStore()
    func switchToScoreboardTab()
    func goToOnlineGame(_ gameID: Int)

    func goToSignUp()
    func goToUpdateProfile()
    func goToInvitation()

    func goToGiftPoint()
    func goToRequestPoint()
}

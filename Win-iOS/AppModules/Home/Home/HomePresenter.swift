//
//
//  HomePresenter.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 25/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//



import Foundation

final class HomePresenter: HomePresenterProtocol {

    weak var view: HomeViewProtocol?
    var interactor: HomeInteractorProtocol?
    var router: HomeRouterProtocol?

    private(set) var homeContents: HomeContents?
    private(set) var redemptionLeaderboard: RedemptionLeaderboard?
    private(set) var campaignsWithLeaderboards: CampaignList?

    private var pendingRequests = 0 {
        didSet { view?.setLoading(pendingRequests > 0) }
    }

    func viewDidLoad() {
        pendingRequests = 3
        interactor?.fetchHomeContents()
        interactor?.fetchRedemptionLeaderboard()
        interactor?.fetchCampaignsWithLeaderboards()
    }

    func didTapStore() {
        router?.goToStore()
    }

    func didTapSwitchToScoreboard() {
        router?.switchToScoreboardTab()
    }

    func didTapOnlineGame(_ gameID: Int) {
        router?.goToOnlineGame(gameID)
    }

    func didTapJourney(journey: Invite?, index: Int) {
        guard !(journey?.isCompleted ?? true) else { return }
        switch index {
        case 0: router?.goToSignUp()
        case 1: router?.goToUpdateProfile()
        case 2: router?.goToInvitation()
        default: break
        }
    }

    func didTapPointTransfer(item: PointTransferDetail) {
        switch item.id {
        case 1: router?.goToGiftPoint()
        case 2: router?.goToRequestPoint()
        default: break
        }
    }
}

// MARK: - Interactor Output
extension HomePresenter: HomeInteractorOutput {

    func homeContentsFetched(_ contents: HomeContents) {
        homeContents = contents
        pendingRequests -= 1
        view?.reloadTableView()
    }

    func homeContentsFailed(_ message: String) {
        pendingRequests -= 1
        view?.showToast(message: message, isError: true)
        view?.reloadTableView()
    }

    func redemptionLeaderboardFetched(_ data: RedemptionLeaderboard) {
        redemptionLeaderboard = data
        pendingRequests -= 1
        view?.reloadTableView()
    }

    func redemptionLeaderboardFailed(_ message: String) {
        pendingRequests -= 1
        view?.showToast(message: message, isError: true)
        view?.reloadTableView()
    }

    func campaignsWithLeaderboardsFetched(_ data: CampaignList) {
        campaignsWithLeaderboards = data
        pendingRequests -= 1
        view?.reloadTableView()
    }

    func campaignsWithLeaderboardsFailed(_ message: String) {
        pendingRequests -= 1
        view?.showToast(message: message, isError: true)
        view?.reloadTableView()
    }
}
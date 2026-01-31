//
//
//  ScoreboardPresenter.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 21/10/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import Foundation

final class ScoreboardPresenter: ScoreboardPresenterProtocol {

    weak var view: ScoreboardViewProtocol?

    // NOTE: keep optional to avoid IUO crash; router wires before use.
    var interactor: ScoreboardInteractorProtocol?
    var router: ScoreboardRouterProtocol?

    private(set) var sections: [ScoreboardSection] = []

    // Data
    private var campaignList: [Campaign] = []
    private var scoreboardCampaign: ScoreboardCampaign?

    private var leaderboardTopThree: [LeaderboardItem] = []
    private var leaderboardRest: [LeaderboardItem] = []
    private var myLeaderboard: LeaderboardItem?

    // MARK: - Presenter API
    func viewDidLoad() {
        view?.setLoading(true)
        interactor?.fetchCampaignList()
    }

    func didSelectCampaign(id: Int) {
        view?.setLoading(true)
        interactor?.fetchScoreboardCampaign(campaignID: id)
    }

    func didTapBack() {
        router?.goBackToHomeTab()
    }

    // MARK: - Data Getters
    func campaigns() -> [Campaign] { campaignList }
    func topThree() -> [LeaderboardItem] { leaderboardTopThree }
    func leaderboard() -> [LeaderboardItem] { leaderboardRest }
    func myPosition() -> LeaderboardItem? { myLeaderboard }

    func redemption() -> RedemptionLeaderboard? {
        scoreboardCampaign?.redemptionLeaderboard
    }

    // MARK: - Build sections (CRITICAL: hides cells if data not available)
    private func rebuildSections() {
        var s: [ScoreboardSection] = []

        if !campaignList.isEmpty { s.append(.campaigns) }

        if !leaderboardTopThree.isEmpty { s.append(.topThree) }
        if !leaderboardRest.isEmpty { s.append(.leaderboard) }
        if myLeaderboard != nil { s.append(.myPosition) }

        if let red = scoreboardCampaign?.redemptionLeaderboard {
            let hasItems = !(red.redemptionLeaderboardItems ?? []).isEmpty
            let hasTotals = (red.totalRedeemAmount ?? 0) > 0 || (red.redemptionCount ?? 0) > 0
            if hasItems || hasTotals {
                s.append(.redemptionWinners)
            }
        }

        sections = s
    }

    private func processLeaderboard() {
        guard
            let items = scoreboardCampaign?.leaderboardItemsList,
            !items.isEmpty
        else {
            leaderboardTopThree = []
            leaderboardRest = []
            myLeaderboard = nil
            return
        }

        let sorted = items.sorted {
            ($0.userRank ?? Int.max) < ($1.userRank ?? Int.max)
        }

        leaderboardTopThree = Array(sorted.prefix(3))

        var rest = Array(sorted.dropFirst(min(3, sorted.count)))
        myLeaderboard = sorted.first(where: { $0.isMyself == true })
        rest.removeAll(where: { $0.isMyself == true })
        leaderboardRest = rest
    }
}

// MARK: - Interactor Output
extension ScoreboardPresenter: ScoreboardInteractorOutput {

    func didFetchCampaignList(_ list: [Campaign]) {
        view?.setLoading(false)

        campaignList = list

        // auto-load first campaign scoreboard
        if let firstID = list.first?.campaignID {
            view?.setLoading(true)
            interactor?.fetchScoreboardCampaign(campaignID: firstID)
        }

        rebuildSections()
        view?.reload()
    }

    func didFetchScoreboardCampaign(_ campaign: ScoreboardCampaign) {
        view?.setLoading(false)

        scoreboardCampaign = campaign
        processLeaderboard()
        rebuildSections()
        view?.reload()
    }

    func didFail(_ message: String) {
        view?.setLoading(false)
        view?.showError(message)
        rebuildSections()
        view?.reload()
    }
}

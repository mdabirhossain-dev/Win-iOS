//
//
//  ScoreboardView.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 12/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//


import UIKit

// MARK: - View
protocol ScoreboardViewProtocol: AnyObject {
    func reload()
    func showError(_ message: String)
    func setLoading(_ isLoading: Bool)
}

// MARK: - Presenter
protocol ScoreboardPresenterProtocol: AnyObject {
    var sections: [ScoreboardSection] { get }

    func viewDidLoad()
    func didSelectCampaign(id: Int)
    func didTapBack()

    func campaigns() -> [Campaign]
    func topThree() -> [LeaderboardItem]
    func leaderboard() -> [LeaderboardItem]
    func myPosition() -> LeaderboardItem?
    func redemption() -> RedemptionLeaderboard?
}

// MARK: - Interactor
protocol ScoreboardInteractorProtocol: AnyObject {
    func fetchCampaignList()
    func fetchScoreboardCampaign(campaignID: Int)
}

protocol ScoreboardInteractorOutput: AnyObject {
    func didFetchCampaignList(_ list: [Campaign])
    func didFetchScoreboardCampaign(_ campaign: ScoreboardCampaign)
    func didFail(_ message: String)
}

// MARK: - Router
protocol ScoreboardRouterProtocol: AnyObject {
    func goBackToHomeTab()
}

// MARK: - Section type
enum ScoreboardSection {
    case campaigns
    case topThree
    case leaderboard
    case myPosition
    case redemptionWinners
}

//
//
//  RedeemScoreProtocols.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 13/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//



import UIKit

// MARK: - View
protocol RedeemScoreViewProtocol: AnyObject {
    var presenter: RedeemScorePresenterProtocol? { get set }

    func setLoading(_ isLoading: Bool)
    func showToast(message: String, isError: Bool)
    func reload()
}

// MARK: - Presenter
protocol RedeemScorePresenterProtocol: AnyObject {
    func viewDidLoad()

    func numberOfSections() -> Int
    func numberOfRows(in section: Int) -> Int
    func sectionTitle(at section: Int) -> String
    func section(at index: Int) -> RedeemScoreSection?
}

// MARK: - Interactor
protocol RedeemScoreInteractorInputProtocol: AnyObject {
    func fetchRedeemScore()
}

protocol RedeemScoreInteractorOutput: AnyObject {
    func redeemScoreFetched(_ data: RedeemScore)
    func redeemScoreFailed(_ message: String)
}

// MARK: - Router
protocol RedeemScoreRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
}

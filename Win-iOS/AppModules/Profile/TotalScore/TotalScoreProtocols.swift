//
//
//  TotalScoreEntity.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 18/11/25.
//  Contact me if anything is needed:
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

// MARK: - View
protocol TotalScoreViewProtocol: AnyObject {
    var presenter: TotalScorePresenterProtocol? { get set }

    func reload()
    func setLoading(_ isLoading: Bool)
    
    func showToast(message: String, isError: Bool)
}

// MARK: - Presenter
protocol TotalScorePresenterProtocol: AnyObject {
    // References
    var view: TotalScoreViewProtocol? { get set }
    var interactor: TotalScoreInteractorInputProtocol? { get set }
    var router: TotalScoreRouterProtocol? { get set }

    // Lifecycle
    func viewDidLoad()
    func setInitial(totalScore: Int)

    // Data source
    func numberOfSections() -> Int
    func numberOfRows(in section: Int) -> Int

    // Cell configuration
    func configureCell(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell
}

// MARK: - Interactor
protocol TotalScoreInteractorInputProtocol: AnyObject {
    var output: TotalScoreInteractorOutputProtocol? { get set }
    func getScoreDetails()
}

protocol TotalScoreInteractorOutputProtocol: AnyObject {
    func didReceiveScoreDetails(_ response: CampaignWiseScores)
    func didFail(_ error: Error)
}

// MARK: - Router
protocol TotalScoreRouterProtocol: AnyObject {
    static func createModule(_ totalScore: Int) -> UIViewController
    func dismiss(from view: TotalScoreViewProtocol?)
}

//
//
//  TotalPointProtocols.swift
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
protocol TotalPointViewProtocol: AnyObject {
    var presenter: TotalPointPresenterProtocol? { get set }

    func reload()
    func setLoading(_ isLoading: Bool)
    
    func showToast(message: String, isError: Bool)
}

// MARK: - Presenter
protocol TotalPointPresenterProtocol: AnyObject {
    // References
    var view: TotalPointViewProtocol? { get set }
    var interactor: TotalPointInteractorInputProtocol? { get set }
    var router: TotalPointRouterProtocol? { get set }
    
    // Lifecycle
    func viewDidLoad()
    func setInitial(totalScore: Int)
    
    // Data source
    func numberOfSections() -> Int
    func numberOfRows(in section: Int) -> Int
    
    // Cell configuration
    func configureCell(_ tableView: UITableView,
                       at indexPath: IndexPath) -> UITableViewCell
}

// MARK: - Interactor
protocol TotalPointInteractorInputProtocol: AnyObject {
    var output: TotalPointInteractorOutputProtocol? { get set }
    func getScoreDetails()
}

protocol TotalPointInteractorOutputProtocol: AnyObject {
    func didReceivePointDetails(_ response: TotalPointResponse)
    func didFail(_ error: Error)
}

// MARK: - Router
protocol TotalPointRouterProtocol: AnyObject {
    static func createModule(_ totalPoint: Int) -> UIViewController
    func dismiss(from view: TotalPointViewProtocol?)
}

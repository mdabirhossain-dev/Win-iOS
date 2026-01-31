//
//
//  InvitationHistoryProtocols.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 30/12/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

// MARK: - View
protocol InvitationHistoryViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func reloadTableView()
    func showError(_ message: String)
}

// MARK: - Presenter
protocol InvitationHistoryPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapBack()

    // Table helpers
    func numberOfItems() -> Int
    func item(at index: Int) -> InvitationResponse?
}

// MARK: - Interactor
protocol InvitationHistoryInteractorInput: AnyObject {
    func fetchInvitationHistory()
}

protocol InvitationHistoryInteractorOutput: AnyObject {
    func invitationHistoryFetched(_ list: InvitationList?)
    func invitationHistoryFailed(_ message: String)
}

// MARK: - Router
protocol InvitationHistoryRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
    func goBack()
}

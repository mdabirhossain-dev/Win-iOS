//
//
//  HelpAndSupportProtocols.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 12/11/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import Foundation

// MARK: - View
protocol HelpAndSupportViewProtocol: AnyObject {
    func setLoading(_ isLoading: Bool)
    func showSuccess(message: String)
    func showError(message: String)
}

// MARK: - Presenter
protocol HelpAndSupportPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapSubmit(
        name: String?,
        phone: String?,
        email: String?,
        message: String?
    )
    func didTapBack()
}

// MARK: - Interactor
protocol HelpAndSupportInteractorInputProtocol: AnyObject {
    func postHelpAndSupport(request: HelpAndSupportRequest)
}

protocol HelpAndSupportInteractorOutputProtocol: AnyObject {
    func postHelpAndSupportSucceeded(responseMessage: String)
    func postHelpAndSupportFailed(error: Error)
    func postHelpAndSupportFailedWithServerMessage(_ message: String)
}

// MARK: - Router
protocol HelpAndSupportRouterProtocol: AnyObject {
    func dismiss(from view: HelpAndSupportViewProtocol?)
}

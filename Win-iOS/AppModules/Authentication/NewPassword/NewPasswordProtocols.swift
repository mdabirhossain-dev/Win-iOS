//
//
//  NewPasswordProtocols.swift
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
protocol NewPasswordViewProtocol: AnyObject {
    func setLoading(_ isLoading: Bool)
    func showValidationError(_ message: String)   // shows errorLabel
    func clearValidationError()
    func showErrorToast(_ message: String)
    func showSuccessAndGoRoot()
}

// MARK: - Presenter
protocol NewPasswordPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapSubmit(newPassword: String?, reenterPassword: String?)
    func didTapBack()
}

// MARK: - Interactor
protocol NewPasswordInteractorProtocol: AnyObject {
    func setPassword(request: ResetPasswordRequest)
}

protocol NewPasswordInteractorOutput: AnyObject {
    func setPasswordSucceeded()
    func setPasswordFailed(_ message: String)
}

// MARK: - Router
protocol NewPasswordRouterProtocol: AnyObject {
    func goBack()
    func goToRootAfterSuccess()
}

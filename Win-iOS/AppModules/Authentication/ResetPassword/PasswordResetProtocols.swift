//
//
//  PasswordResetProtocols.swift
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
protocol PasswordResetViewProtocol: AnyObject {
    func setLoading(_ isLoading: Bool)
    func showValidationError(_ message: String)   // shows errorLabel
    func clearValidationError()
    func showErrorToast(_ message: String)
}

// MARK: - Presenter
protocol PasswordResetPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapSubmit(msisdn: String?)
    func didChangePhoneText(_ text: String?)
    func didTapBack()
}

// MARK: - Interactor
protocol PasswordResetInteractorProtocol: AnyObject {
    func checkRegistrationAndRequestOTP(msisdn: String)
}

protocol PasswordResetInteractorOutput: AnyObject {
    func otpRequestSucceeded(msisdn: String)
    func otpRequestFailed(_ message: String)
}

// MARK: - Router
protocol PasswordResetRouterProtocol: AnyObject {
    func goBack()
    func goToOTP(msisdn: String)
}

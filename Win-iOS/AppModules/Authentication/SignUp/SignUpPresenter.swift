//
//
//  SignUpPresenter.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 15/10/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

// MARK: - Presenter
private enum SignUpUIError: LocalizedError {
    case emptyPhone
    case emptyPassword

    var errorDescription: String? {
        switch self {
        case .emptyPhone: return "ফোন নম্বর দিন"
        case .emptyPassword: return "পাসওয়ার্ড দিন"
        }
    }
}

final class SignUpPresenter: SignUpPresenterProtocol {

    weak var view: SignUpViewProtocol?
    var interactor: SignUpInteractorInputProtocol?
    var router: SignUpRouterProtocol?

    func viewDidLoad() { }

    func didTapSignUp(userInfo: SignUpUserInfo) {
        let msisdn = userInfo.msisdn.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = (userInfo.password ?? "").trimmingCharacters(in: .whitespacesAndNewlines)

        guard !msisdn.isEmpty else {
            view?.showToast(message: SignUpUIError.emptyPhone.localizedDescription, isError: true)
            return
        }

        guard !password.isEmpty else {
            view?.showToast(message: SignUpUIError.emptyPassword.localizedDescription, isError: true)
            return
        }

        view?.showLoading()

        interactor?.getUserRegistrationStatus(msisdn: msisdn) { result in
            DispatchQueue.main.async {
                self.view?.hideLoading()

                switch result {
                case .success:
                    self.router?.navigateToOtpVerificationScreen(userInfo: userInfo)

                case .failure(let error):
                    // ✅ server response error/message
                    self.view?.showToast(message: error.localizedDescription, isError: true)
                }
            }
        }
    }

    func didTapSignUpWithApple() { }
    func didTapSignUpWithGoogle() { }
    func didTapSignUpWithFacebook() { }
}

extension SignUpPresenter: SignUpInteractorOutputProtocol {
    func signUpDidSucceed(response: AlertMessage) { }
    func signUpDidFail(error: any Error) { }
}

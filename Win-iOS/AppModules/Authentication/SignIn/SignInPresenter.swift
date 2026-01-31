//
//
//  SignInPresenter.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 14/10/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

// MARK: - Presenter
private enum SignInUIError: LocalizedError {
    case emptyPhone
    case emptyPassword
    case authFailed(message: String?)

    var errorDescription: String? {
        switch self {
        case .emptyPhone:
            return "ফোন নম্বর দিন"
        case .emptyPassword:
            return "পাসওয়ার্ড দিন"
        case .authFailed(let message):
            let msg = message?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            return msg.isEmpty ? "ফোন নম্বর বা পাসওয়ার্ড সঠিক নয়" : msg
        }
    }
}

final class SignInPresenter: SignInPresenterProtocol {

    weak var view: SignInViewProtocol?
    var interactor: SignInInteractorInputProtocol?
    var router: SignInRouterProtocol?

    func viewDidLoad() { }

    func didTapRememberMe(_ isSelected: Bool) {
        Log.info("Save user credentials")
    }

    func didTapForgotPassword() {
        router?.navigateToForgotPasswordScreen()
    }

    func didTapSignIn(phone: String?, password: String?, isSaveCredentials: Bool) {
        let phone = (phone ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let password = (password ?? "").trimmingCharacters(in: .whitespacesAndNewlines)

        guard !phone.isEmpty else {
            view?.showToast(message: SignInUIError.emptyPhone.localizedDescription, isError: true)
            return
        }

        guard !password.isEmpty else {
            view?.showToast(message: SignInUIError.emptyPassword.localizedDescription, isError: true)
            return
        }

        view?.showLoading()
        interactor?.signIn(
            request: SignInRequest(msisdn: phone, password: password),
            isSaveCredentials: isSaveCredentials
        )
    }

    func didTapRegister() {
        router?.navigateToSignUpScreen()
    }

    func didTapSignInWithApple() {
        interactor?.signInWithApple(request: ResendOtpRequest(msisdn: "", otpEvent: .signIn))
    }

    func didTapSignInWithGoogle() {
        interactor?.signInWithGoogle(request: ResendOtpRequest(msisdn: "", otpEvent: .signIn))
    }

    func didTapSignInWithFacebook() {
        interactor?.signInWithFacebook(request: ResendOtpRequest(msisdn: "", otpEvent: .signIn))
    }
}

extension SignInPresenter: SignInInteractorOutputProtocol {

    func signInDidSucceed(response: SignInResponse) {
        view?.hideLoading()

        if response.isAuthenticated == true {
            router?.navigateToHomeScreen()
        } else {
            view?.showToast(
                message: SignInUIError.authFailed(message: response.message).localizedDescription,
                isError: true
            )
        }
    }

    func signInDidFail(error: Error) {
        view?.hideLoading()
        Log.info(error)
        view?.showToast(message: error.localizedDescription, isError: true)
    }
}

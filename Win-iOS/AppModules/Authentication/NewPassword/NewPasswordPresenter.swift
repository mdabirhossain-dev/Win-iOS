//
//
//  NewPasswordPresenter.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 12/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//



import Foundation

final class NewPasswordPresenter: NewPasswordPresenterProtocol {

    weak var view: NewPasswordViewProtocol?

    var interactor: NewPasswordInteractorProtocol?
    var router: NewPasswordRouterProtocol?

    private let msisdn: String
    private let otp: String

    init(msisdn: String, otp: String) {
        self.msisdn = msisdn
        self.otp = otp
    }

    func viewDidLoad() {
        view?.setLoading(false)
        view?.clearValidationError()
    }

    func didTapSubmit(newPassword: String?, reenterPassword: String?) {
        let password = (newPassword ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let re = (reenterPassword ?? "").trimmingCharacters(in: .whitespacesAndNewlines)

        guard !password.isEmpty else {
            view?.showValidationError("নতুন পাসওয়ার্ড লিখুন")
            return
        }

        guard !re.isEmpty else {
            view?.showValidationError("পাসওয়ার্ডটি পুনরায় লিখুন")
            return
        }

        guard password == re else {
            view?.showValidationError("পাসওয়ার্ড মিলছে না")
            return
        }

        view?.clearValidationError()
        view?.setLoading(true)

        let request = ResetPasswordRequest(
            msisdn: "88\(msisdn)",
            password: password,
            otp: otp
        )
        interactor?.setPassword(request: request)
    }

    func didTapBack() {
        router?.goBack()
    }
}

// MARK: - Interactor Output
extension NewPasswordPresenter: NewPasswordInteractorOutput {

    func setPasswordSucceeded() {
        view?.setLoading(false)
        view?.showSuccessAndGoRoot()
    }

    func setPasswordFailed(_ message: String) {
        view?.setLoading(false)
        view?.showErrorToast(message)
    }
}
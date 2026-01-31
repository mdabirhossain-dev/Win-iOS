//
//
//  PasswordResetPresenter.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 12/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//



import Foundation

final class PasswordResetPresenter: PasswordResetPresenterProtocol {

    weak var view: PasswordResetViewProtocol?

    var interactor: PasswordResetInteractorProtocol?
    var router: PasswordResetRouterProtocol?

    func viewDidLoad() {
        view?.setLoading(false)
        view?.clearValidationError()
    }

    func didChangePhoneText(_ text: String?) {
        // We keep trimming/limit logic in VC (because it needs to set the field text),
        // so presenter doesn’t mutate UI state.
        // This exists only if you want to extend later.
        _ = text
    }

    func didTapSubmit(msisdn: String?) {
        let raw = (msisdn ?? "").trimmingCharacters(in: .whitespacesAndNewlines)

        guard !raw.isEmpty else {
            view?.showValidationError("ফোন নাম্বার লিখুন")
            return
        }

        // optional: basic length guard (your UI already limits to 11)
        guard raw.count >= 11 else {
            view?.showValidationError("সঠিক ফোন নাম্বার লিখুন")
            return
        }

        view?.clearValidationError()
        view?.setLoading(true)
        interactor?.checkRegistrationAndRequestOTP(msisdn: raw)
    }

    func didTapBack() {
        router?.goBack()
    }
}

extension PasswordResetPresenter: PasswordResetInteractorOutput {

    func otpRequestSucceeded(msisdn: String) {
        view?.setLoading(false)
        router?.goToOTP(msisdn: msisdn)
    }

    func otpRequestFailed(_ message: String) {
        view?.setLoading(false)
        view?.showErrorToast(message)
    }
}
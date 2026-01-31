//
//
//  OtpVerificationPresenter.swift
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
final class OtpVerificationPresenter: OtpVerificationPresenterProtocol {

    weak var view: OtpVerificationViewProtocol?
    var interactor: OtpVerificationInteractorInputProtocol?
    var router: OtpVerificationRouterProtocol?

    private let userInfo: SignUpUserInfo
    private var otp = ""
    private var otpEvent: OtpEvent

    private var resendTimer: Timer?
    private var resendCountdown: Int = 0
    private let resendDuration: Int = 60

    init(userInfo: SignUpUserInfo, otpEvent: OtpEvent) {
        self.userInfo = userInfo
        self.otpEvent = otpEvent
    }

    func viewDidLoad() {
        startResendTimer()
    }

    func didTapSubmit(otp: String?) {
        let otp = (otp ?? "").trimmingCharacters(in: .whitespacesAndNewlines)

        // ✅ Toast-only validation
        guard !otp.isEmpty else {
            view?.showToast(message: "OTP দিন", isError: true)
            return
        }

        guard otp.count == 6 else {
            view?.showToast(message: "OTP অবশ্যই ৬ সংখ্যার হতে হবে", isError: true)
            return
        }

        guard otp.allSatisfy({ $0.isNumber }) else {
            view?.showToast(message: "OTP শুধু সংখ্যা হতে হবে", isError: true)
            return
        }

        self.otp = otp
        view?.showLoading()

        let request = OtpVerificationRequest(msisdn: "88\(userInfo.msisdn)", password: otp)
        interactor?.verifyOtp(request: request)
    }

    func didTapResendOtp() {
        view?.showLoading()
        let request = ResendOtpRequest(msisdn: userInfo.msisdn, otpEvent: otpEvent)
        interactor?.resendOtp(request: request)
    }

    private func startResendTimer() {
        resendCountdown = resendDuration
        updateResendButtonTitle()

        resendTimer?.invalidate()
        resendTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self else { return }
            self.resendCountdown -= 1

            if self.resendCountdown <= 0 {
                self.stopResendTimer()
            } else {
                self.updateResendButtonTitle()
            }
        }
    }

    private func stopResendTimer() {
        resendTimer?.invalidate()
        resendTimer = nil
        view?.updateResendButton(enabled: true, title: AppConstants.Auth.sendAgain)
    }

    private func updateResendButtonTitle() {
        view?.updateResendButton(enabled: false, title: "Resend in \(resendCountdown)s")
    }

    deinit { resendTimer?.invalidate() }
}

// MARK: - Output
extension OtpVerificationPresenter: OtpVerificationInteractorOutputProtocol {

    func otpVerificationDidSucceed() {
        view?.hideLoading()
        view?.showToast(message: "OTP verified", isError: false)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self else { return }

            switch self.otpEvent {
            case .signIn:
                break
            case .signUp:
                let request = SignUpRequest(
                    msisdn: "88\(self.userInfo.msisdn)",
                    password: self.userInfo.password ?? "",
                    fullName: "Your Name",
                    dateOfBirth: "2024-01-06T00:00:00Z",
                    gender: "Undefined",
                    otp: self.otp,
                    invitationCode: self.userInfo.invitationCode ?? ""
                )
                self.interactor?.signUp(request: request)

            case .forgotPassword:
                self.router?.navigateToNextScreen(msisdn: self.userInfo.msisdn, otp: self.otp)
            }
        }
    }

    func otpVerificationDidFail(error: Error) {
        view?.hideLoading()
        view?.showToast(message: error.localizedDescription, isError: true)
    }

    func otpResendDidSucceed() {
        view?.hideLoading()
        view?.showToast(message: "OTP পাঠানো হয়েছে", isError: false)
        view?.clearOtpField()
        startResendTimer()
    }

    func otpResendDidFail(error: Error) {
        view?.hideLoading()
        view?.showToast(message: error.localizedDescription, isError: true)
        stopResendTimer()
    }

    func signUpDidSucceed() {
        Alert.show(
            AlertConfig(
                title: "সফল হয়েছে",
                message: "আপনার রেজিস্ট্রেশন সম্পন্ন হয়েছে",
                icon: .lottie(.success, loop: .loop, speed: 1.0),
                buttons: .ok(title: "ঠিক আছে")
            ),
            onOK: { [weak self] in
                self?.router?.navigateBackToSignInScreen()
            }
        )
    }

    func signUpDidFail(error: Error) {
        view?.hideLoading()
        view?.showToast(message: error.localizedDescription, isError: true)
    }
}

//
//
//  OtpVerificationViewToPresenterProtocol.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 14/10/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//



import UIKit

// MARK: - Protocol Contracts
protocol OtpVerificationViewProtocol: AnyObject {
    var presenter: OtpVerificationPresenterProtocol? { get set }

    func showLoading()
    func hideLoading()
    func showToast(message: String, isError: Bool)
    func updateResendButton(enabled: Bool, title: String)
    func clearOtpField()
}

protocol OtpVerificationPresenterProtocol: AnyObject {
    var view: OtpVerificationViewProtocol? { get set }
    var interactor: OtpVerificationInteractorInputProtocol? { get set }
    var router: OtpVerificationRouterProtocol? { get set }

    func viewDidLoad()
    func didTapSubmit(otp: String?)
    func didTapResendOtp()
}

protocol OtpVerificationInteractorInputProtocol: AnyObject {
    var presenter: OtpVerificationInteractorOutputProtocol? { get set }

    func verifyOtp(request: OtpVerificationRequest)
    func resendOtp(request: ResendOtpRequest)
    func signUp(request: SignUpRequest)
}

protocol OtpVerificationInteractorOutputProtocol: AnyObject {
    func otpVerificationDidSucceed()
    func otpVerificationDidFail(error: Error)

    func otpResendDidSucceed()
    func otpResendDidFail(error: Error)

    func signUpDidSucceed()
    func signUpDidFail(error: Error)
}

protocol OtpVerificationRouterProtocol: AnyObject {
    static func createModule(userInfo: SignUpUserInfo, otpEvent: OtpEvent) -> UIViewController
    func navigateToNextScreen(msisdn: String, otp: String)
    func navigateBackToSignInScreen()
    func dismissView()
}

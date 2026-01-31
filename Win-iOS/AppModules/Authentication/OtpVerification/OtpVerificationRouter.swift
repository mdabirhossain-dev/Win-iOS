//
//
//  OtpVerificationRouter.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 14/10/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//

import UIKit

// MARK: - Router
final class OtpVerificationRouter: OtpVerificationRouterProtocol {

    weak var viewController: UIViewController?

    static func createModule(userInfo: SignUpUserInfo, otpEvent: OtpEvent) -> UIViewController {
        let view = OtpVerificationViewController()
        let presenter = OtpVerificationPresenter(userInfo: userInfo, otpEvent: otpEvent)
        let interactor = OtpVerificationInteractor()
        let router = OtpVerificationRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.viewController = view

        view.setPhoneNumber(userInfo.msisdn)
        return view
    }

    func navigateToNextScreen(msisdn: String, otp: String) {
        viewController?.navigationController?.pushViewController(.newPassword(msisdn: msisdn, otp: otp), animated: true)
        Log.info("✅ OTP Verified - Navigate to next screen")
    }

    func navigateBackToSignInScreen() {
        viewController?.navigationController?.logoutAndGoToSignIn()
    }

    func dismissView() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}

//
//
//  PasswordResetRouter.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 12/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//



import UIKit

final class PasswordResetRouter: PasswordResetRouterProtocol {

    weak var viewController: UIViewController?

    static func createModule() -> UIViewController {
        let view = PasswordResetViewController()

        let presenter = PasswordResetPresenter()
        let interactor = PasswordResetInteractor()
        let router = PasswordResetRouter()

        view.presenter = presenter

        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router

        interactor.output = presenter
        router.viewController = view

        return view
    }

    func goBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }

    func goToOTP(msisdn: String) {
        let userInfo = SignUpUserInfo(msisdn: msisdn, password: nil, invitationCode: nil)
        viewController?.navigationController?.pushViewController(
            .otpVerification(userInfo: userInfo, otpEvent: .forgotPassword),
            animated: true
        )
    }
}

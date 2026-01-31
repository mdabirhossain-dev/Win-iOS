//
//
//  SignUpRouter.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 15/10/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

// MARK: - Router
class SignUpRouter: SignUpRouterProtocol {

    weak var viewController: UIViewController?

    static func createModule() -> UIViewController {
        let view = SignUpViewController()
        let presenter = SignUpPresenter()
        let interactor = SignUpInteractor()
        let router = SignUpRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.viewController = view

        return view
    }

    func navigateBackToSignInScreen() {
        viewController?.navigationController?.popViewController(animated: true)
    }

    func navigateToOtpVerificationScreen(userInfo: SignUpUserInfo) {
        viewController?.navigationController?.pushViewController(.otpVerification(userInfo: userInfo, otpEvent: .signUp), animated: true)
    }

    func dismissView() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}

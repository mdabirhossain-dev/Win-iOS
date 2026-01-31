//
//
//  SignInRouter.swift
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
class SignInRouter: SignInRouterProtocol {
    weak var viewController: UIViewController?

    static func createModule() -> UIViewController {
        let view = SignInViewController()
        let presenter = SignInPresenter()
        let interactor = SignInInteractor()
        let router = SignInRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.viewController = view

        return view
    }

    func navigateToForgotPasswordScreen() {
        Log.info("tapped on forgot password")
        viewController?.navigationController?.pushViewController(.forgotPassword, animated: true)
    }

    func navigateToHomeScreen() {
        Log.info("tapped on home")
        viewController?.navigationController?.setViewControllers(.tabBar, animated: true)
    }

    func navigateToSignUpScreen() {
        Log.info("tapped on sign up")
        viewController?.navigationController?.pushViewController(.signUp, animated: true)
    }
}

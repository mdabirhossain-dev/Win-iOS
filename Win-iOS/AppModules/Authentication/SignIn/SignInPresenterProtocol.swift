//
//
//  SignInPresenterProtocol.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 14/10/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

protocol SignInViewProtocol: AnyObject {
    var presenter: SignInPresenterProtocol? { get set }

    func showLoading()
    func hideLoading()
    func showInlineError(message: String)
    func hideInlineError()
    func showToast(message: String, isError: Bool)
    func updateResendButton(enabled: Bool, title: String)
}

protocol SignInPresenterProtocol: AnyObject {
    var view: SignInViewProtocol? { get set }
    var interactor: SignInInteractorInputProtocol? { get set }
    var router: SignInRouterProtocol? { get set }

    func viewDidLoad()
    func didTapRememberMe(_ isSelected: Bool)
    func didTapForgotPassword()
    func didTapSignIn(phone: String?, password: String?, isSaveCredentials: Bool)
    func didTapRegister()
    func didTapSignInWithApple()
    func didTapSignInWithGoogle()
    func didTapSignInWithFacebook()
}

protocol SignInInteractorInputProtocol: AnyObject {
    var presenter: SignInInteractorOutputProtocol? { get set }

    func signIn(request: SignInRequest, isSaveCredentials: Bool)
    func signInWithApple(request: ResendOtpRequest)
    func signInWithGoogle(request: ResendOtpRequest)
    func signInWithFacebook(request: ResendOtpRequest)
}

protocol SignInInteractorOutputProtocol: AnyObject {
    func signInDidSucceed(response: SignInResponse)
    func signInDidFail(error: Error)
}

protocol SignInRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
    func navigateToForgotPasswordScreen()
    func navigateToHomeScreen()
    func navigateToSignUpScreen()
}

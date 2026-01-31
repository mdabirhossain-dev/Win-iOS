//
//
//  SignUpViewProtocol.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 15/10/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

protocol SignUpViewProtocol: AnyObject {
    var presenter: SignUpPresenterProtocol? { get set }
    
    func showLoading()
    func hideLoading()
    func showInlineError(message: String)
    func hideInlineError()
    func showToast(message: String, isError: Bool)
    func updateResendButton(enabled: Bool, title: String)
}

protocol SignUpPresenterProtocol: AnyObject {
    var view: SignUpViewProtocol? { get set }
    var interactor: SignUpInteractorInputProtocol? { get set }
    var router: SignUpRouterProtocol? { get set }
    
    func viewDidLoad()
    func didTapSignUp(userInfo: SignUpUserInfo)
    func didTapSignUpWithApple()
    func didTapSignUpWithGoogle()
    func didTapSignUpWithFacebook()
}

protocol SignUpInteractorInputProtocol: AnyObject {
    var presenter: SignUpInteractorOutputProtocol? { get set }
    
//    func signUp(request: OtpVerificationRequest)
    func getUserRegistrationStatus(msisdn: String, completion: @escaping (Result<Bool, Error>) -> Void)
    func requestOTP(msisdn: String, completion: @escaping (Result<Bool, Error>) -> Void)
    func signUpWithApple(request: ResendOtpRequest)
    func signUpWithGoogle(request: ResendOtpRequest)
    func signUpWithFacebook(request: ResendOtpRequest)
}

protocol SignUpInteractorOutputProtocol: AnyObject {
    func signUpDidSucceed(response: AlertMessage)
    func signUpDidFail(error: Error)
}

protocol SignUpRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
    func navigateBackToSignInScreen()
    func navigateToOtpVerificationScreen(userInfo: SignUpUserInfo)
    func dismissView()
}

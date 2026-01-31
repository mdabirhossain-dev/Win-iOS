//
//
//  SignInPresenterTests.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 12/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//


import XCTest
@testable import Win_iOS

final class SignInPresenterTests: XCTestCase {

    private var presenter: SignInPresenter!
    private var view: MockSignInView!
    private var interactor: MockSignInInteractor!
    private var router: MockSignInRouter!

    override func setUp() {
        super.setUp()
        presenter = SignInPresenter()
        view = MockSignInView()
        interactor = MockSignInInteractor()
        router = MockSignInRouter()

        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
    }

    func test_didTapSignIn_emptyPhone_showsToast_andDoesNotCallInteractor() {
        presenter.didTapSignIn(phone: "", password: "1234", isSaveCredentials: true)

        XCTAssertEqual(view.toastMessages.count, 1)
        XCTAssertTrue(view.toastMessages[0].isError)
        XCTAssertNil(interactor.lastRequest)
        XCTAssertEqual(view.showLoadingCount, 0)
    }

    func test_didTapSignIn_emptyPassword_showsToast_andDoesNotCallInteractor() {
        presenter.didTapSignIn(phone: "017xxxxxxxx", password: "", isSaveCredentials: true)

        XCTAssertEqual(view.toastMessages.count, 1)
        XCTAssertTrue(view.toastMessages[0].isError)
        XCTAssertNil(interactor.lastRequest)
        XCTAssertEqual(view.showLoadingCount, 0)
    }

    func test_didTapSignIn_validInputs_showsLoading_andCallsInteractor() {
        presenter.didTapSignIn(phone: "017xxxxxxxx", password: "pass", isSaveCredentials: true)

        XCTAssertEqual(view.showLoadingCount, 1)
        XCTAssertNotNil(interactor.lastRequest)
        XCTAssertEqual(interactor.lastRequest?.msisdn, "017xxxxxxxx")
        XCTAssertEqual(interactor.lastRequest?.password, "pass")
        XCTAssertEqual(interactor.lastIsSaveCredentials, true)
    }

    func test_signInDidSucceed_authenticated_hidesLoading_andNavigatesHome() {
        view.showLoading()

        presenter.signInDidSucceed(response: SignInResponse(
            message: "ok",
            isAuthenticated: true,
            msisdn: "017",
            token: "t",
            earnedPoints: nil, signupPoints: nil, invitationPoints: nil,
            signupImage: nil, appSigninImage: nil,
            appSigninPoints: nil
        ))

        XCTAssertEqual(view.hideLoadingCount, 1)
        XCTAssertEqual(router.navigateHomeCount, 1)
        XCTAssertTrue(view.toastMessages.isEmpty)
    }

    func test_signInDidSucceed_notAuthenticated_hidesLoading_showsToast_noNavigation() {
        view.showLoading()

        presenter.signInDidSucceed(response: SignInResponse(
            message: "Invalid credentials",
            isAuthenticated: false,
            msisdn: nil,
            token: nil,
            earnedPoints: nil, signupPoints: nil, invitationPoints: nil,
            signupImage: nil, appSigninImage: nil,
            appSigninPoints: nil
        ))

        XCTAssertEqual(view.hideLoadingCount, 1)
        XCTAssertEqual(router.navigateHomeCount, 0)
        XCTAssertEqual(view.toastMessages.count, 1)
        XCTAssertTrue(view.toastMessages[0].isError)
    }

    func test_signInDidFail_hidesLoading_showsToast() {
        view.showLoading()

        presenter.signInDidFail(error: DummyError())

        XCTAssertEqual(view.hideLoadingCount, 1)
        XCTAssertEqual(view.toastMessages.count, 1)
        XCTAssertTrue(view.toastMessages[0].isError)
    }
}

// MARK: - Mocks

private final class MockSignInView: SignInViewProtocol {
    var presenter: SignInPresenterProtocol?

    var showLoadingCount = 0
    var hideLoadingCount = 0
    var toastMessages: [(message: String, isError: Bool)] = []

    func showLoading() { showLoadingCount += 1 }
    func hideLoading() { hideLoadingCount += 1 }

    func showInlineError(message: String) { }
    func hideInlineError() { }

    func showToast(message: String, isError: Bool) {
        toastMessages.append((message, isError))
    }

    func updateResendButton(enabled: Bool, title: String) { }
}

private final class MockSignInInteractor: SignInInteractorInputProtocol {
    weak var presenter: SignInInteractorOutputProtocol?

    var lastRequest: SignInRequest?
    var lastIsSaveCredentials: Bool?

    func signIn(request: SignInRequest, isSaveCredentials: Bool) {
        lastRequest = request
        lastIsSaveCredentials = isSaveCredentials
    }

    func signInWithApple(request: ResendOtpRequest) { }
    func signInWithGoogle(request: ResendOtpRequest) { }
    func signInWithFacebook(request: ResendOtpRequest) { }
}

private final class MockSignInRouter: SignInRouterProtocol {
    static func createModule() -> UIViewController { UIViewController() }

    var navigateHomeCount = 0

    func navigateToForgotPasswordScreen() { }
    func navigateToHomeScreen() { navigateHomeCount += 1 }
    func navigateToSignUpScreen() { }
}

private struct DummyError: LocalizedError {
    var errorDescription: String? { "Network error" }
}

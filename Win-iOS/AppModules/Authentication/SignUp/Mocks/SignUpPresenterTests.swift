//
//
//  SignUpPresenterTests.swift
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

final class SignUpPresenterTests: XCTestCase {

    private var presenter: SignUpPresenter!
    private var view: MockSignUpView!
    private var interactor: MockSignUpInteractor!
    private var router: MockSignUpRouter!

    override func setUp() {
        super.setUp()
        presenter = SignUpPresenter()
        view = MockSignUpView()
        interactor = MockSignUpInteractor()
        router = MockSignUpRouter()

        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
    }

    func test_didTapSignUp_emptyPhone_showsToast_noLoading_noInteractor() {
        presenter.didTapSignUp(userInfo: SignUpUserInfo(msisdn: "", password: "p", invitationCode: "x"))

        XCTAssertEqual(view.toastMessages.count, 1)
        XCTAssertTrue(view.toastMessages[0].isError)
        XCTAssertEqual(view.showLoadingCount, 0)
        XCTAssertEqual(interactor.callCount, 0)
    }

    func test_didTapSignUp_emptyPassword_showsToast_noLoading_noInteractor() {
        presenter.didTapSignUp(userInfo: SignUpUserInfo(msisdn: "017", password: "", invitationCode: "x"))

        XCTAssertEqual(view.toastMessages.count, 1)
        XCTAssertTrue(view.toastMessages[0].isError)
        XCTAssertEqual(view.showLoadingCount, 0)
        XCTAssertEqual(interactor.callCount, 0)
    }

    func test_didTapSignUp_valid_showsLoading_callsInteractor() {
        presenter.didTapSignUp(userInfo: SignUpUserInfo(msisdn: "017", password: "p", invitationCode: "x"))

        XCTAssertEqual(view.showLoadingCount, 1)
        XCTAssertEqual(interactor.callCount, 1)
    }

    func test_didTapSignUp_success_hidesLoading_navigatesToOtp() {
        let exp = expectation(description: "async completion")
        interactor.nextResult = .success(true)

        presenter.didTapSignUp(userInfo: SignUpUserInfo(msisdn: "017", password: "p", invitationCode: "x"))

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            XCTAssertEqual(self.view.hideLoadingCount, 1)
            XCTAssertEqual(self.router.navigateOtpCount, 1)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
    }

    func test_didTapSignUp_failure_hidesLoading_showsToast_noNavigation() {
        let exp = expectation(description: "async completion")
        interactor.nextResult = .failure(DummyError())

        presenter.didTapSignUp(userInfo: SignUpUserInfo(msisdn: "017", password: "p", invitationCode: "x"))

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            XCTAssertEqual(self.view.hideLoadingCount, 1)
            XCTAssertEqual(self.router.navigateOtpCount, 0)
            XCTAssertEqual(self.view.toastMessages.count, 1)
            XCTAssertTrue(self.view.toastMessages[0].isError)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
    }
}

// MARK: - Mocks

private final class MockSignUpView: SignUpViewProtocol {
    var presenter: SignUpPresenterProtocol?

    var showLoadingCount = 0
    var hideLoadingCount = 0
    var toastMessages: [(message: String, isError: Bool)] = []

    func showLoading() { showLoadingCount += 1 }
    func hideLoading() { hideLoadingCount += 1 }
    func showInlineError(message: String) { }
    func hideInlineError() { }
    func showToast(message: String, isError: Bool) { toastMessages.append((message, isError)) }
    func updateResendButton(enabled: Bool, title: String) { }
}

private final class MockSignUpInteractor: SignUpInteractorInputProtocol {
    weak var presenter: SignUpInteractorOutputProtocol?

    var callCount = 0
    var nextResult: Result<Bool, Error> = .success(true)

    func getUserRegistrationStatus(msisdn: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        callCount += 1
        completion(nextResult)
    }

    func requestOTP(msisdn: String, completion: @escaping (Result<Bool, Error>) -> Void) { }
    func signUpWithApple(request: ResendOtpRequest) { }
    func signUpWithGoogle(request: ResendOtpRequest) { }
    func signUpWithFacebook(request: ResendOtpRequest) { }
}

private final class MockSignUpRouter: SignUpRouterProtocol {
    static func createModule() -> UIViewController { UIViewController() }

    var navigateOtpCount = 0

    func navigateBackToSignInScreen() { }
    func navigateToOtpVerificationScreen(userInfo: SignUpUserInfo) { navigateOtpCount += 1 }
    func dismissView() { }
}

private struct DummyError: LocalizedError {
    var errorDescription: String? { "Already registered user" }
}

//
//
//  OtpVerificationPresenterTests.swift
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

final class OtpVerificationPresenterTests: XCTestCase {

    func test_submit_emptyOtp_showsToast_noInteractor() {
        let (p, v, i, _) = makeSUT()

        p.didTapSubmit(otp: "")

        XCTAssertEqual(v.toasts.count, 1)
        XCTAssertTrue(v.toasts[0].isError)
        XCTAssertEqual(i.verifyCalls, 0)
    }

    func test_submit_wrongLength_showsToast_noInteractor() {
        let (p, v, i, _) = makeSUT()

        p.didTapSubmit(otp: "123")

        XCTAssertEqual(v.toasts.count, 1)
        XCTAssertTrue(v.toasts[0].isError)
        XCTAssertEqual(i.verifyCalls, 0)
    }

    func test_submit_nonNumeric_showsToast_noInteractor() {
        let (p, v, i, _) = makeSUT()

        p.didTapSubmit(otp: "12AB56")

        XCTAssertEqual(v.toasts.count, 1)
        XCTAssertTrue(v.toasts[0].isError)
        XCTAssertEqual(i.verifyCalls, 0)
    }

    func test_submit_valid_callsInteractor_andShowsLoading() {
        let (p, v, i, _) = makeSUT()

        p.didTapSubmit(otp: "123456")

        XCTAssertEqual(v.showLoadingCount, 1)
        XCTAssertEqual(i.verifyCalls, 1)
    }

    // MARK: - Helpers

    private func makeSUT() -> (OtpVerificationPresenter, MockOtpView, MockOtpInteractor, MockOtpRouter) {
        let user = SignUpUserInfo(msisdn: "01700000000", password: "p", invitationCode: "x")
        let presenter = OtpVerificationPresenter(userInfo: user, otpEvent: .signUp)

        let view = MockOtpView()
        let interactor = MockOtpInteractor()
        let router = MockOtpRouter()

        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router

        return (presenter, view, interactor, router)
    }
}

// MARK: - Mocks

private final class MockOtpView: OtpVerificationViewProtocol {
    var presenter: OtpVerificationPresenterProtocol?

    var showLoadingCount = 0
    var hideLoadingCount = 0

    // ✅ Named tuple fields (fixes your error)
    var toasts: [(message: String, isError: Bool)] = []

    func showLoading() { showLoadingCount += 1 }
    func hideLoading() { hideLoadingCount += 1 }

    func showToast(message: String, isError: Bool) {
        toasts.append((message: message, isError: isError))
    }

    func updateResendButton(enabled: Bool, title: String) { }
    func clearOtpField() { }
}

private final class MockOtpInteractor: OtpVerificationInteractorInputProtocol {
    weak var presenter: OtpVerificationInteractorOutputProtocol?

    var verifyCalls = 0
    var resendCalls = 0

    func verifyOtp(request: OtpVerificationRequest) { verifyCalls += 1 }
    func resendOtp(request: ResendOtpRequest) { resendCalls += 1 }
    func signUp(request: SignUpRequest) { }
}

private final class MockOtpRouter: OtpVerificationRouterProtocol {
    static func createModule(userInfo: SignUpUserInfo, otpEvent: OtpEvent) -> UIViewController {
        UIViewController()
    }

    func navigateToNextScreen(msisdn: String, otp: String) { }
    func navigateBackToSignInScreen() { }
    func dismissView() { }
}

//
//
//  PasswordResetPresenterTests.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 13/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//


import XCTest
@testable import Win_iOS

final class PasswordResetPresenterTests: XCTestCase {

    // MARK: - SUT Builder
    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: PasswordResetPresenter,
          view: MockPasswordResetView,
          interactor: MockPasswordResetInteractor,
          router: MockPasswordResetRouter) {

        let view = MockPasswordResetView()
        let interactor = MockPasswordResetInteractor()
        let router = MockPasswordResetRouter()

        let sut = PasswordResetPresenter()
        sut.view = view
        sut.interactor = interactor
        sut.router = router

        view.presenter = sut

        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(interactor, file: file, line: line)
        trackForMemoryLeaks(router, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)

        return (sut, view, interactor, router)
    }

    func test_viewDidLoad_setsLoadingFalse_andClearsValidationError() {
        let (sut, view, _, _) = makeSUT()

        sut.viewDidLoad()

        XCTAssertEqual(view.loadingStates, [false])
        XCTAssertEqual(view.clearValidationErrorCallCount, 1)
    }

    func test_didTapSubmit_withNil_showsValidationError() {
        let (sut, view, _, _) = makeSUT()

        sut.didTapSubmit(msisdn: nil)

        XCTAssertEqual(view.validationErrors, ["ফোন নাম্বার লিখুন"])
    }

    func test_didTapSubmit_withEmpty_showsValidationError() {
        let (sut, view, _, _) = makeSUT()

        sut.didTapSubmit(msisdn: "   ")

        XCTAssertEqual(view.validationErrors, ["ফোন নাম্বার লিখুন"])
    }

    func test_didTapSubmit_withShortNumber_showsValidationError() {
        let (sut, view, _, _) = makeSUT()

        sut.didTapSubmit(msisdn: "017123")

        XCTAssertEqual(view.validationErrors, ["সঠিক ফোন নাম্বার লিখুন"])
    }

    func test_didTapSubmit_withValidNumber_clearsError_setsLoadingTrue_andCallsInteractor() {
        let (sut, view, interactor, _) = makeSUT()

        sut.didTapSubmit(msisdn: "01711111111")

        XCTAssertEqual(view.clearValidationErrorCallCount, 1)
        XCTAssertEqual(view.loadingStates.last, true)
        XCTAssertEqual(interactor.checkCallCount, 1)
        XCTAssertEqual(interactor.lastMSISDN, "01711111111")
    }

    func test_didTapBack_callsRouterGoBack() {
        let (sut, _, _, router) = makeSUT()

        sut.didTapBack()

        XCTAssertEqual(router.goBackCallCount, 1)
    }

    func test_otpRequestSucceeded_setsLoadingFalse_andRoutesToOTP() {
        let (sut, view, _, router) = makeSUT()
        sut.viewDidLoad()

        sut.otpRequestSucceeded(msisdn: "01711111111")

        XCTAssertEqual(view.loadingStates.last, false)
        XCTAssertEqual(router.goToOTPCalls, ["01711111111"])
    }

    func test_otpRequestFailed_setsLoadingFalse_andShowsErrorToast() {
        let (sut, view, _, _) = makeSUT()
        sut.viewDidLoad()

        sut.otpRequestFailed("Boom")

        XCTAssertEqual(view.loadingStates.last, false)
        XCTAssertEqual(view.toasts, [.init(message: "Boom", isError: true)])
    }
}

// MARK: - Mocks

private struct ToastEvent: Equatable {
    let message: String
    let isError: Bool
}

private final class MockPasswordResetView: PasswordResetViewProtocol {
    var presenter: PasswordResetPresenterProtocol?

    private(set) var loadingStates: [Bool] = []
    private(set) var validationErrors: [String] = []
    private(set) var clearValidationErrorCallCount = 0
    private(set) var toasts: [ToastEvent] = []

    func setLoading(_ isLoading: Bool) { loadingStates.append(isLoading) }

    func showValidationError(_ message: String) {
        validationErrors.append(message)
    }

    func clearValidationError() { clearValidationErrorCallCount += 1 }

    func showErrorToast(_ message: String) {
        toasts.append(.init(message: message, isError: true))
    }
}

private final class MockPasswordResetInteractor: PasswordResetInteractorProtocol {
    private(set) var checkCallCount = 0
    private(set) var lastMSISDN: String?

    func checkRegistrationAndRequestOTP(msisdn: String) {
        checkCallCount += 1
        lastMSISDN = msisdn
    }
}

private final class MockPasswordResetRouter: PasswordResetRouterProtocol {
    private(set) var goBackCallCount = 0
    private(set) var goToOTPCalls: [String] = []

    func goBack() { goBackCallCount += 1 }
    func goToOTP(msisdn: String) { goToOTPCalls.append(msisdn) }
}

// MARK: - Helpers

private extension XCTestCase {
    func trackForMemoryLeaks(
        _ instance: AnyObject,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Possible memory leak.", file: file, line: line)
        }
    }
}

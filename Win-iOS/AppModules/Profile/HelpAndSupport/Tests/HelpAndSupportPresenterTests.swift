//
//
//  HelpAndSupportPresenterTests.swift
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

final class HelpAndSupportPresenterTests: XCTestCase {

    func test_submit_emptyName_showsError_noInteractor() {
        let (p, v, i) = makeSUT()
        p.didTapSubmit(name: "", phone: "8801700000000", email: "a@b.com", message: "hi")
        XCTAssertEqual(v.errors.count, 1)
        XCTAssertEqual(i.postCalls, 0)
    }

    func test_submit_emptyEmail_showsError_noInteractor() {
        let (p, v, i) = makeSUT()
        p.didTapSubmit(name: "A", phone: "8801700000000", email: "", message: "hi")
        XCTAssertEqual(v.errors.count, 1)
        XCTAssertEqual(i.postCalls, 0)
    }

    func test_submit_invalidEmail_showsError_noInteractor() {
        let (p, v, i) = makeSUT()
        p.didTapSubmit(name: "A", phone: "8801700000000", email: "abc", message: "hi")
        XCTAssertEqual(v.errors.count, 1)
        XCTAssertEqual(i.postCalls, 0)
    }

    func test_submit_emptyMessage_showsError_noInteractor() {
        let (p, v, i) = makeSUT()
        p.didTapSubmit(name: "A", phone: "8801700000000", email: "a@b.com", message: "")
        XCTAssertEqual(v.errors.count, 1)
        XCTAssertEqual(i.postCalls, 0)
    }

    func test_submit_valid_callsInteractor_andSetsLoadingTrue() {
        let (p, v, i) = makeSUT()
        p.didTapSubmit(name: "A", phone: "8801700000000", email: "a@b.com", message: "hello")
        XCTAssertEqual(v.loadingStates, [true])
        XCTAssertEqual(i.postCalls, 1)
    }

    // MARK: - Helpers

    private func makeSUT() -> (HelpAndSupportPresenter, MockHelpSupportView, MockHelpSupportInteractor) {
        let view = MockHelpSupportView()
        let interactor = MockHelpSupportInteractor()
        let router = MockHelpSupportRouter()

        let presenter = HelpAndSupportPresenter(view: view, interactor: interactor, router: router)
        interactor.output = presenter

        return (presenter, view, interactor)
    }
}

// MARK: - Mocks

private final class MockHelpSupportView: HelpAndSupportViewProtocol {

    var loadingStates: [Bool] = []
    var errors: [String] = []
    var successes: [String] = []

    func setLoading(_ isLoading: Bool) { loadingStates.append(isLoading) }
    func showSuccess(message: String) { successes.append(message) }
    func showError(message: String) { errors.append(message) }
}

private final class MockHelpSupportInteractor: HelpAndSupportInteractorInputProtocol {

    weak var output: HelpAndSupportInteractorOutputProtocol?
    var postCalls = 0
    var lastRequest: HelpAndSupportRequest?

    func postHelpAndSupport(request: HelpAndSupportRequest) {
        postCalls += 1
        lastRequest = request
    }
}

private final class MockHelpSupportRouter: HelpAndSupportRouterProtocol {
    func dismiss(from view: HelpAndSupportViewProtocol?) { }
}
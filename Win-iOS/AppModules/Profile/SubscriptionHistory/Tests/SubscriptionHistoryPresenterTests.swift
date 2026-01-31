//
//
//  SubscriptionHistoryPresenterTests.swift
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

final class SubscriptionHistoryPresenterTests: XCTestCase {

    func test_error_showsToastAndHidesLoading() {
        let (p, v) = makeSUT()

        p.didReceivedErrorWhileFetchingSubscriptionHistory(error: NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Boom"]))

        XCTAssertEqual(v.hideLoadingCallCount, 1)
        XCTAssertEqual(v.toasts.count, 1)
        XCTAssertEqual(v.toasts[0].0, "Boom")
        XCTAssertEqual(v.toasts[0].1, true)
    }

    func test_success_setsHistory_reload_andHidesLoading() {
        let (p, v) = makeSUT()

        p.didReceivedSubscriptionHistory(history: [])

        XCTAssertNotNil(p.historys)
        XCTAssertEqual(v.reloadCallCount, 1)
        XCTAssertEqual(v.hideLoadingCallCount, 1)
        XCTAssertEqual(v.toasts.count, 0)
    }

    // MARK: - Helpers

    private func makeSUT() -> (SubscriptionHistoryPresenter, MockSubscriptionHistoryView) {
        let presenter = SubscriptionHistoryPresenter()
        let view = MockSubscriptionHistoryView()
        presenter.view = view
        return (presenter, view)
    }
}

private final class MockSubscriptionHistoryView: SubscriptionHistoryViewProtocol {

    var presenter: SubscriptionHistoryPresenterProtocol?

    private(set) var showLoadingCallCount = 0
    private(set) var hideLoadingCallCount = 0
    private(set) var reloadCallCount = 0
    private(set) var toasts: [(String, Bool)] = []

    func showLoading() { showLoadingCallCount += 1 }
    func hideLoading() { hideLoadingCallCount += 1 }
    func reloadTableView() { reloadCallCount += 1 }

    func showToast(message: String, isError: Bool) {
        toasts.append((message, isError))
    }
}
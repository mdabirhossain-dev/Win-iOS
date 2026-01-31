//
//
//  TotalScorePresenterTests.swift
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

final class TotalScorePresenterTests: XCTestCase {

    func test_viewDidLoad_setsLoading_andFetches() {
        let (p, v, i) = makeSUT()

        p.viewDidLoad()

        XCTAssertEqual(v.setLoadingCalls, [true])
        XCTAssertEqual(i.getScoreDetailsCallCount, 1)
    }

    func test_success_hidesLoading_andReloads() {
        let (p, v, _) = makeSUT()

        p.didReceiveScoreDetails([])

        XCTAssertEqual(v.setLoadingCalls.last, false)
        XCTAssertEqual(v.reloadCallCount, 1)
        XCTAssertEqual(v.toasts.count, 0)
    }

    func test_serverError_showsServerMessageAsIs() {
        let (p, v, _) = makeSUT()

        let err = NSError(domain: "TotalScoreServer", code: 500,
                          userInfo: [NSLocalizedDescriptionKey: "Invalid Token"])
        p.didFail(err)

        XCTAssertEqual(v.toasts.count, 1)
        XCTAssertEqual(v.toasts[0].0, "Invalid Token")
        XCTAssertEqual(v.toasts[0].1, true)
    }

    func test_nonServerError_showsBanglaFallback() {
        let (p, v, _) = makeSUT()

        let err = URLError(.notConnectedToInternet)
        p.didFail(err)

        XCTAssertEqual(v.toasts.count, 1)
        XCTAssertEqual(v.toasts[0].0, "ইন্টারনেট সংযোগ নেই")
        XCTAssertEqual(v.toasts[0].1, true)
    }

    // MARK: - Helpers
    private func makeSUT() -> (TotalScorePresenter, MockTotalScoreView, MockTotalScoreInteractor) {
        let presenter = TotalScorePresenter()
        let view = MockTotalScoreView()
        let interactor = MockTotalScoreInteractor()

        presenter.view = view
        presenter.interactor = interactor
        view.presenter = presenter
        interactor.output = presenter

        return (presenter, view, interactor)
    }
}

private final class MockTotalScoreView: TotalScoreViewProtocol {
    var presenter: TotalScorePresenterProtocol?

    private(set) var reloadCallCount = 0
    private(set) var setLoadingCalls: [Bool] = []
    private(set) var toasts: [(String, Bool)] = []

    func reload() { reloadCallCount += 1 }
    func setLoading(_ isLoading: Bool) { setLoadingCalls.append(isLoading) }

    func showToast(message: String, isError: Bool) {
        toasts.append((message, isError))
    }
}

private final class MockTotalScoreInteractor: TotalScoreInteractorInputProtocol {
    weak var output: TotalScoreInteractorOutputProtocol?

    private(set) var getScoreDetailsCallCount = 0
    func getScoreDetails() { getScoreDetailsCallCount += 1 }
}

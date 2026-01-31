//
//
//  TotalPointPresenterTests.swift
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

final class TotalPointPresenterTests: XCTestCase {

    func test_viewDidLoad_showsLoading_andFetches() {
        let (p, v, i) = makeSUT()

        p.viewDidLoad()

        XCTAssertEqual(v.setLoadingCalls, [true])
        XCTAssertEqual(i.getScoreDetailsCallCount, 1)
    }

    func test_success_hidesLoading_andReloads() {
        let (p, v, _) = makeSUT()

        p.didReceivePointDetails(TotalPointResponse(totalPoints: 10, pointsBreakdown: []))

        XCTAssertEqual(v.setLoadingCalls.last, false)
        XCTAssertEqual(v.reloadCallCount, 1)
        XCTAssertEqual(v.toasts.count, 0)
    }

    func test_failure_hidesLoading_andShowsToast() {
        let (p, v, _) = makeSUT()

        p.didFail(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Server says nope"]))

        XCTAssertEqual(v.setLoadingCalls.last, false)
        XCTAssertEqual(v.toasts.count, 1)
        XCTAssertEqual(v.toasts[0].0, "Server says nope")
        XCTAssertEqual(v.toasts[0].1, true)
    }

    // MARK: - Helpers

    private func makeSUT() -> (TotalPointPresenter, MockTotalPointView, MockTotalPointInteractor) {
        let presenter = TotalPointPresenter()
        let view = MockTotalPointView()
        let interactor = MockTotalPointInteractor()
        presenter.view = view
        presenter.interactor = interactor
        view.presenter = presenter
        interactor.output = presenter
        return (presenter, view, interactor)
    }
}

private final class MockTotalPointView: TotalPointViewProtocol {
    var presenter: TotalPointPresenterProtocol?

    private(set) var reloadCallCount = 0
    private(set) var setLoadingCalls: [Bool] = []
    private(set) var toasts: [(String, Bool)] = []

    func reload() { reloadCallCount += 1 }
    func setLoading(_ isLoading: Bool) { setLoadingCalls.append(isLoading) }

    func showToast(message: String, isError: Bool) {
        toasts.append((message, isError))
    }
}

private final class MockTotalPointInteractor: TotalPointInteractorInputProtocol {
    weak var output: TotalPointInteractorOutputProtocol?

    private(set) var getScoreDetailsCallCount = 0
    func getScoreDetails() { getScoreDetailsCallCount += 1 }
}
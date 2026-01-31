//
//
//  RedeemScorePresenterTests.swift
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

final class RedeemScorePresenterTests: XCTestCase {

    // MARK: - SUT Builder
    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: RedeemScorePresenter,
          view: MockRedeemScoreView,
          interactor: MockRedeemScoreInteractor,
          router: MockRedeemScoreRouter) {

        let view = MockRedeemScoreView()
        let interactor = MockRedeemScoreInteractor()
        let router = MockRedeemScoreRouter()

        let sut = RedeemScorePresenter()
        sut.view = view
        sut.interactor = interactor
        sut.router = router

        view.presenter = sut
        interactor.output = sut

        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(interactor, file: file, line: line)
        trackForMemoryLeaks(router, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)

        return (sut, view, interactor, router)
    }

    // MARK: - Tests

    func test_viewDidLoad_setsLoadingTrue_andFetchesRedeemScore() {
        let (sut, view, interactor, _) = makeSUT()

        sut.viewDidLoad()

        XCTAssertEqual(view.loadingStates, [true])
        XCTAssertEqual(interactor.fetchCallCount, 1)
    }

    func test_redeemScoreFetched_setsLoadingFalse_buildsSections_andReloads() throws {
        let (sut, view, _, _) = makeSUT()
        sut.viewDidLoad()

        // totalScore + giftVouchers => 2 sections
        let data: RedeemScore = try TestJSON.makeRedeemScore(totalScore: 10, giftVouchersCount: 2, cashbackCount: 0)
        sut.redeemScoreFetched(data)

        XCTAssertEqual(view.loadingStates.last, false)
        XCTAssertEqual(view.reloadCallCount, 1)
        XCTAssertEqual(sut.numberOfSections(), 2)
        XCTAssertEqual(sut.sectionTitle(at: 0), "Total Score")
        XCTAssertEqual(sut.sectionTitle(at: 1), "Gift Vouchers")
    }

    func test_redeemScoreFailed_setsLoadingFalse_clearsSections_showsToast_andReloads() {
        let (sut, view, _, _) = makeSUT()
        sut.viewDidLoad()

        sut.redeemScoreFailed("Boom")

        XCTAssertEqual(view.loadingStates.last, false)
        XCTAssertEqual(sut.numberOfSections(), 0)
        XCTAssertEqual(view.toasts.count, 1)
        XCTAssertEqual(view.toasts[0].message, "Boom")
        XCTAssertTrue(view.toasts[0].isError)
        XCTAssertEqual(view.reloadCallCount, 1)
    }
}

// MARK: - Mocks

private struct ToastEvent: Equatable {
    let message: String
    let isError: Bool
}

private final class MockRedeemScoreView: RedeemScoreViewProtocol {
    var presenter: RedeemScorePresenterProtocol?

    private(set) var loadingStates: [Bool] = []
    private(set) var reloadCallCount = 0
    private(set) var toasts: [ToastEvent] = []

    func setLoading(_ isLoading: Bool) { loadingStates.append(isLoading) }
    func reload() { reloadCallCount += 1 }
    func showToast(message: String, isError: Bool) {
        toasts.append(.init(message: message, isError: isError))
    }
}

private final class MockRedeemScoreInteractor: RedeemScoreInteractorInputProtocol {
    weak var output: RedeemScoreInteractorOutput?
    private(set) var fetchCallCount = 0

    func fetchRedeemScore() { fetchCallCount += 1 }
}

private final class MockRedeemScoreRouter: RedeemScoreRouterProtocol {
    static func createModule() -> UIViewController { UIViewController() }
}

// MARK: - Test Helpers

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

// MARK: - JSON Builder (NO model initializers needed)

private enum TestJSON {

    static func makeRedeemScore(
        totalScore: Int?,
        giftVouchersCount: Int,
        cashbackCount: Int
    ) throws -> RedeemScore {

        let gift = Array(repeating: [:] as [String: Any], count: giftVouchersCount)
        let cash = Array(repeating: [:] as [String: Any], count: cashbackCount)

        var obj: [String: Any] = [:]
        if let totalScore { obj["totalScore"] = totalScore }
        obj["giftVouchers"] = gift
        obj["cashback"] = cash

        return try decode(obj, as: RedeemScore.self)
    }

    private static func decode<T: Decodable>(_ object: Any, as type: T.Type) throws -> T {
        let data = try JSONSerialization.data(withJSONObject: object, options: [])
        return try JSONDecoder().decode(T.self, from: data)
    }
}

//
//
//  InvitationHistoryPresenterTests.swift
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

final class InvitationHistoryPresenterTests: XCTestCase {
    
    private var presenter: InvitationHistoryPresenter!
    private var view: InvitationHistoryViewMock!
    private var interactor: InvitationHistoryInteractorMock!
    private var router: InvitationHistoryRouterMock!

    override func setUp() {
        super.setUp()

        presenter = InvitationHistoryPresenter()

        view = InvitationHistoryViewMock()
        interactor = InvitationHistoryInteractorMock()
        router = InvitationHistoryRouterMock()

        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
    }

    override func tearDown() {
        presenter = nil
        view = nil
        interactor = nil
        router = nil
        super.tearDown()
    }

    func test_viewDidLoad_showsLoading_andFetches() {
        presenter.viewDidLoad()

        XCTAssertEqual(view.showLoadingCallCount, 1)
        XCTAssertEqual(interactor.fetchInvitationHistoryCallCount, 1)
    }

    func test_invitationHistoryFetched_hidesLoading_reload_andStoresData() {
        let list: InvitationList = [
            InvitationResponse(
                invitationMappingID: 1,
                msisdn: "8801712345678",
                invitationCode: "ABC",
                codeGenerationDate: "2026-01-01",
                invitedBy: "88019XXXXXXX",
                joinDate: "2026-01-01",
                joinDateBengali: "১ জানুয়ারি ২০২৬",
                point: 10
            )
        ]

        presenter.invitationHistoryFetched(list)

        XCTAssertEqual(view.hideLoadingCallCount, 1)
        XCTAssertEqual(view.reloadTableViewCallCount, 1)
        XCTAssertEqual(presenter.numberOfItems(), 1)
        XCTAssertEqual(presenter.item(at: 0)?.msisdn, "8801712345678")
    }

    func test_invitationHistoryFetched_nil_clearsData_andReloads() {
        presenter.invitationHistoryFetched(nil)

        XCTAssertEqual(view.hideLoadingCallCount, 1)
        XCTAssertEqual(view.reloadTableViewCallCount, 1)
        XCTAssertEqual(presenter.numberOfItems(), 0)
    }

    func test_invitationHistoryFailed_hidesLoading_showsError_clearsData_andReloads() {
        // seed
        presenter.invitationHistoryFetched([
            InvitationResponse(
                invitationMappingID: 1,
                msisdn: "8801712345678",
                invitationCode: nil,
                codeGenerationDate: nil,
                invitedBy: nil,
                joinDate: nil,
                joinDateBengali: "১ জানুয়ারি ২০২৬",
                point: 10
            )
        ])
        XCTAssertEqual(presenter.numberOfItems(), 1)

        presenter.invitationHistoryFailed("Failed to load")

        XCTAssertEqual(view.hideLoadingCallCount, 2) // one from fetched + one from failed
        XCTAssertEqual(view.showErrorCallCount, 1)
        XCTAssertEqual(view.lastErrorMessage, "Failed to load")
        XCTAssertEqual(view.reloadTableViewCallCount, 2)
        XCTAssertEqual(presenter.numberOfItems(), 0)
    }

    func test_didTapBack_callsRouterGoBack() {
        presenter.didTapBack()
        XCTAssertEqual(router.goBackCallCount, 1)
    }

    func test_item_outOfBounds_returnsNil() {
        presenter.invitationHistoryFetched(nil)
        XCTAssertNil(presenter.item(at: 999))
    }
}

// MARK: - Mocks

private final class InvitationHistoryViewMock: InvitationHistoryViewProtocol {
    private(set) var showLoadingCallCount = 0
    private(set) var hideLoadingCallCount = 0
    private(set) var reloadTableViewCallCount = 0
    private(set) var showErrorCallCount = 0
    private(set) var lastErrorMessage: String?

    func showLoading() { showLoadingCallCount += 1 }
    func hideLoading() { hideLoadingCallCount += 1 }
    func reloadTableView() { reloadTableViewCallCount += 1 }

    func showError(_ message: String) {
        showErrorCallCount += 1
        lastErrorMessage = message
    }
}

private final class InvitationHistoryInteractorMock: InvitationHistoryInteractorInput {
    private(set) var fetchInvitationHistoryCallCount = 0
    func fetchInvitationHistory() { fetchInvitationHistoryCallCount += 1 }
}

private final class InvitationHistoryRouterMock: InvitationHistoryRouterProtocol {
    static func createModule() -> UIViewController { UIViewController() }
    private(set) var goBackCallCount = 0
    func goBack() { goBackCallCount += 1 }
}

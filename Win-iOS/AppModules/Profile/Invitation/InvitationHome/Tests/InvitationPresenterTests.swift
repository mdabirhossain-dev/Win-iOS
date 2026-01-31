//
//
//  InvitationPresenterTests.swift
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

final class InvitationPresenterTests: XCTestCase {

    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: InvitationPresenter,
          view: MockInvitationView,
          interactor: MockInvitationInteractor,
          router: MockInvitationRouter) {

        let view = MockInvitationView()
        let interactor = MockInvitationInteractor()
        let router = MockInvitationRouter()

        let sut = InvitationPresenter()
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

    func test_viewDidLoad_setsLoadingTrue_andFetchesInvitation() {
        let (sut, view, interactor, _) = makeSUT()

        sut.viewDidLoad()

        XCTAssertEqual(view.loadingStates, [true])
        XCTAssertEqual(interactor.fetchInvitationInfoCallCount, 1)
    }

    func test_invitationInfoFetched_setsLoadingFalse_andRendersData_andShowsUI() {
        let (sut, view, _, _) = makeSUT()
        sut.viewDidLoad()

        let response = InvitationResponse(
            invitationMappingID: nil,
            msisdn: nil,
            invitationCode: "ABC123",
            codeGenerationDate: nil,
            invitedBy: nil,
            joinDate: nil,
            joinDateBengali: nil,
            point: 15
        )

        sut.invitationInfoFetched(response)

        XCTAssertEqual(view.loadingStates.last, false)
        XCTAssertEqual(view.visibleStates.last, true)
        XCTAssertEqual(view.pointsTexts.last, "১৫ পয়েন্ট")
        XCTAssertEqual(view.codeTexts.last, "  ABC123")
    }

    func test_invitationInfoFetched_withEmptyCode_hidesCodeAndShareUI() {
        let (sut, view, _, _) = makeSUT()
        sut.viewDidLoad()

        let response = InvitationResponse(
            invitationMappingID: nil,
            msisdn: nil,
            invitationCode: "   ",
            codeGenerationDate: nil,
            invitedBy: nil,
            joinDate: nil,
            joinDateBengali: nil,
            point: 0
        )

        sut.invitationInfoFetched(response)

        XCTAssertEqual(view.visibleStates.last, false)
    }

    func test_invitationInfoFailed_setsLoadingFalse_hidesUI_andShowsErrorToast() {
        let (sut, view, _, _) = makeSUT()
        sut.viewDidLoad()

        sut.invitationInfoFailed("Boom")

        XCTAssertEqual(view.loadingStates.last, false)
        XCTAssertEqual(view.visibleStates.last, false)
        XCTAssertEqual(view.toasts.count, 1)
        XCTAssertEqual(view.toasts[0].message, "Boom")
        XCTAssertTrue(view.toasts[0].isError)
    }

    func test_didTapHistory_navigatesToHistory() {
        let (sut, _, _, router) = makeSUT()

        sut.didTapHistory(navigationController: UINavigationController())

        XCTAssertEqual(router.navigateHistoryCallCount, 1)
    }

    func test_shareMessage_returnsNil_whenNoCode() {
        let (sut, _, _, _) = makeSUT()
        sut.invitationInfoFetched(
            InvitationResponse(
                invitationMappingID: nil,
                msisdn: nil,
                invitationCode: "",
                codeGenerationDate: nil,
                invitedBy: nil,
                joinDate: nil,
                joinDateBengali: nil,
                point: 10
            )
        )

        XCTAssertNil(sut.shareMessage())
    }

    func test_shareMessage_containsCodeAndLink_whenCodeExists() {
        let (sut, _, _, _) = makeSUT()
        sut.invitationInfoFetched(
            InvitationResponse(
                invitationMappingID: nil,
                msisdn: nil,
                invitationCode: "ABC123",
                codeGenerationDate: nil,
                invitedBy: nil,
                joinDate: nil,
                joinDateBengali: nil,
                point: 10
            )
        )

        let msg = sut.shareMessage()
        XCTAssertNotNil(msg)
        XCTAssertTrue(msg?.contains("ABC123") == true)
        XCTAssertTrue(msg?.contains(APIConstants.winWebHomeURL) == true)
    }
}

// MARK: - Mocks

private struct ToastEvent: Equatable {
    let message: String
    let isError: Bool
}

private final class MockInvitationView: InvitationViewProtocol {
    var presenter: InvitationPresenterProtocol?

    private(set) var loadingStates: [Bool] = []
    private(set) var toasts: [ToastEvent] = []

    private(set) var pointsTexts: [String] = []
    private(set) var codeTexts: [String] = []
    private(set) var visibleStates: [Bool] = []

    func setLoading(_ isLoading: Bool) { loadingStates.append(isLoading) }

    func showToast(message: String, isError: Bool) {
        toasts.append(.init(message: message, isError: isError))
    }

    func setInvitation(pointsText: String, codeText: String) {
        pointsTexts.append(pointsText)
        codeTexts.append(codeText)
    }

    func setInvitationUIVisible(_ isVisible: Bool) {
        visibleStates.append(isVisible)
    }
}

private final class MockInvitationInteractor: InvitationInteractorInputProtocol {
    weak var output: InvitationInteractorOutput?

    private(set) var fetchInvitationInfoCallCount = 0

    func fetchInvitationInfo() {
        fetchInvitationInfoCallCount += 1
    }
}

private final class MockInvitationRouter: InvitationRouterProtocol {
    static func createModule() -> UIViewController { UIViewController() }

    private(set) var navigateHistoryCallCount = 0

    func navigateToHistory(from navigationController: UINavigationController?) {
        navigateHistoryCallCount += 1
    }
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

//
//
//  ProfilePresenterTests.swift
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

final class ProfilePresenterTests: XCTestCase {

    // MARK: - SUT Builder
    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: ProfilePresenter,
          view: MockProfileView,
          interactor: MockProfileInteractor,
          router: MockProfileRouter) {

        let view = MockProfileView()
        let interactor = MockProfileInteractor()
        let router = MockProfileRouter()

        let sut = ProfilePresenter()
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

    func test_viewDidLoad_buildsInitialSections() {
        let (sut, _, _, _) = makeSUT()

        sut.viewDidLoad()

        // base: userInfo, points, lakhpoti, campaignScores, journey
        // + 9 options + 2 socials + signOut = 5 + 9 + 2 + 1 = 17
        XCTAssertEqual(sut.numberOfSections(), 17)
    }

    func test_viewWillAppear_setsLoadingTrue_andFetchesSummary() {
        let (sut, view, interactor, _) = makeSUT()
        sut.viewDidLoad()

        sut.viewWillAppear()

        XCTAssertEqual(view.loadingStates, [true])
        XCTAssertEqual(interactor.fetchUserSummaryCallCount, 1)
    }

    func test_didReceiveUserSummary_setsLoadingFalse_andReloads() {
        let (sut, view, _, _) = makeSUT()
        sut.viewDidLoad()

        sut.didReceiveUserSummary(.stub())

        XCTAssertEqual(view.loadingStates.last, false)
        XCTAssertEqual(view.reloadCallCount, 1)
    }

    func test_didFail_showsErrorToast_inBanglaOrServerMessage() {
        let (sut, view, _, _) = makeSUT()
        sut.viewDidLoad()

        sut.didFail(NSError(domain: "x", code: 0, userInfo: [NSLocalizedDescriptionKey: "Boom"]))

        XCTAssertEqual(view.toasts.count, 1)
        XCTAssertEqual(view.toasts[0].message, "Boom")
        XCTAssertTrue(view.toasts[0].isError) // ✅ Works because we use a struct (not tuple)
    }

    func test_selectTotalPoint_navigatesToTotalPoint() {
        let (sut, _, _, router) = makeSUT()
        sut.viewDidLoad()
        sut.didReceiveUserSummary(.stub(userPoint: 55, userScore: 99))

        // section 1 = points, item 0 = totalPoint
        sut.didSelectItem(at: IndexPath(item: 0, section: 1), navigationController: UINavigationController())

        XCTAssertEqual(router.navigations.count, 1)
        guard case let .totalPoint(value) = router.navigations[0] else {
            return XCTFail("Expected .totalPoint route")
        }
        XCTAssertEqual(value, 55)
    }

    func test_selectTotalScore_navigatesToTotalScore() {
        let (sut, _, _, router) = makeSUT()
        sut.viewDidLoad()
        sut.didReceiveUserSummary(.stub(userPoint: 55, userScore: 99))

        // section 1 = points, item 1 = totalScore
        sut.didSelectItem(at: IndexPath(item: 1, section: 1), navigationController: UINavigationController())

        XCTAssertEqual(router.navigations.count, 1)
        guard case let .totalScore(value) = router.navigations[0] else {
            return XCTFail("Expected .totalScore route")
        }
        XCTAssertEqual(value, 99)
    }

    func test_selectRequestPoint_navigatesToRequestPoint_withSummary() {
        let (sut, _, _, router) = makeSUT()
        sut.viewDidLoad()
        let summary = UserSummaryResponse.stub(msisdn: "8801711111111")
        sut.didReceiveUserSummary(summary)

        // Sections:
        // 0 userInfo
        // 1 points
        // 2 lakhpoti
        // 3 campaignScores
        // 4 journey
        // options start at 5:
        // option[0]=redeemScore -> section 5
        // option[1]=requestPoint -> section 6 ✅
        sut.didSelectItem(at: IndexPath(item: 0, section: 6), navigationController: UINavigationController())

        XCTAssertEqual(router.navigations.count, 1)
        guard case let .requestPoint(received) = router.navigations[0] else {
            return XCTFail("Expected .requestPoint route")
        }
        XCTAssertEqual(received?.msisdn, "8801711111111")
    }

    func test_selectHelpAndSupport_navigatesToHelpAndSupport() {
        let (sut, _, _, router) = makeSUT()
        sut.viewDidLoad()

        // option[4]=helpAndSupport => section 5 + 4 = 9 ✅
        sut.didSelectItem(at: IndexPath(item: 0, section: 9), navigationController: UINavigationController())

        XCTAssertEqual(router.navigations.count, 1)
        guard case .helpAndSupport = router.navigations[0] else {
            return XCTFail("Expected .helpAndSupport route")
        }
    }

    func test_selectTelegram_callsOpenSocialTelegram() {
        let (sut, _, _, router) = makeSUT()
        sut.viewDidLoad()

        // options end at section 13 (5..13)
        // socials: section 14 telegram, section 15 facebook
        sut.didSelectItem(at: IndexPath(item: 0, section: 14), navigationController: UINavigationController())

        XCTAssertEqual(router.openSocialCalls, [.telegram])
    }

    func test_selectSignOut_callsSignOut() {
        let (sut, _, _, router) = makeSUT()
        sut.viewDidLoad()

        // signOut is last => 16
        sut.didSelectItem(at: IndexPath(item: 0, section: 16), navigationController: UINavigationController())

        XCTAssertEqual(router.signOutCallCount, 1)
    }
}

// MARK: - Mocks

private struct ToastEvent: Equatable {
    let message: String
    let isError: Bool
}

private final class MockProfileView: ProfileViewProtocol {
    var presenter: ProfilePresenterProtocol?

    private(set) var reloadCallCount = 0
    private(set) var loadingStates: [Bool] = []
    private(set) var toasts: [ToastEvent] = []

    func reload() { reloadCallCount += 1 }
    func setLoading(_ isLoading: Bool) { loadingStates.append(isLoading) }

    func showToast(message: String, isError: Bool) {
        toasts.append(.init(message: message, isError: isError))
    }
}

private final class MockProfileInteractor: ProfileInteractorInputProtocol {
    weak var output: ProfileInteractorOutputProtocol?

    private(set) var fetchUserSummaryCallCount = 0

    func fetchUserSummary() {
        fetchUserSummaryCallCount += 1
    }
}

private final class MockProfileRouter: ProfileRouterProtocol {
    static func createModule() -> UIViewController { UIViewController() }

    private(set) var navigations: [ProfileRoute] = []
    private(set) var openSocialCalls: [SocialLinkType] = []
    private(set) var showRatePromptCallCount = 0
    private(set) var signOutCallCount = 0
    private(set) var dismissToHomeTabCallCount = 0

    func dismissToHomeTab(from vc: UIViewController) {
        dismissToHomeTabCallCount += 1
    }

    func navigate(to destination: ProfileRoute, from navigationController: UINavigationController?) {
        navigations.append(destination)
    }

    func showRatePrompt() { showRatePromptCallCount += 1 }

    func openSocial(_ type: SocialLinkType) {
        openSocialCalls.append(type)
    }

    func signOut(from navigationController: UINavigationController?) {
        signOutCallCount += 1
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

// MARK: - Stubs

private extension UserSummaryResponse {
    static func stub(
        msisdn: String? = "8801700000000",
        fullName: String? = "Test User",
        gender: String? = "Male",
        userAvatarId: Int? = 1,
        avatarImage: String? = "https://example.com/a.png",
        userPoint: Int? = 10,
        userScore: Int? = 20,
        campaignWiseScores: [CampaignWiseScore]? = nil,
        userJourneyProgress: UserJourneyProgress? = nil
    ) -> UserSummaryResponse {
        UserSummaryResponse(
            msisdn: msisdn,
            fullName: fullName,
            dateOfBirth: nil,
            gender: gender,
            userRank: nil,
            userLevel: nil,
            totalScore: nil,
            scoreBreakdown: nil,
            campaignWiseScores: campaignWiseScores,
            playTimeInMilliseconds: nil,
            userAvatarId: userAvatarId,
            avatarImage: avatarImage,
            userJourneyProgress: userJourneyProgress,
            genericTermsAndConditions: nil,
            lakhopotiRedeemDetails: nil,
            userPoint: userPoint,
            userScore: userScore
        )
    }
}

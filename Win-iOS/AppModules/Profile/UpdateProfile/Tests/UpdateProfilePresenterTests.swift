//
//
//  UpdateProfilePresenterTests.swift
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

final class UpdateProfilePresenterTests: XCTestCase {

    func test_viewDidLoad_fetchesAvatarAndList_andShowsLoading() {
        let sut = makeSUT()

        sut.presenter.viewDidLoad()

        XCTAssertEqual(sut.view.loading, [true])
        XCTAssertEqual(sut.interactor.fetchAvatarCallCount, 1)
        XCTAssertEqual(sut.interactor.fetchAvatarListCallCount, 1)
    }

    func test_didTapSave_whenNoChange_showsToast() {
        let sut = makeSUT(fullName: "John", avatarId: "10")

        sut.presenter.didTapSave(enteredName: "John") // unchanged

        XCTAssertEqual(sut.view.toasts.last?.message, "আপডেট করার জন্য তথ্য পরিবর্তন করুন")
        XCTAssertEqual(sut.interactor.updateCallCount, 0)
    }

    func test_didTapSave_whenNameEmpty_showsBanglaError() {
        let sut = makeSUT(fullName: "John", avatarId: "10")

        sut.presenter.didTapSave(enteredName: "   ")

        XCTAssertEqual(sut.view.toasts.last?.message, "নাম খালি রাখা যাবে না")
        XCTAssertEqual(sut.interactor.updateCallCount, 0)
    }

    func test_didTapSave_whenNameChanged_callsUpdate() {
        let sut = makeSUT(fullName: "John", avatarId: "10")

        sut.presenter.didTapSave(enteredName: "John Doe")

        XCTAssertEqual(sut.interactor.updateCallCount, 1)
        XCTAssertEqual(sut.view.loading.last, true)
    }

    func test_didFail_withServerMessage_showsServerMessage() {
        let sut = makeSUT()

        sut.presenter.didFail(NSError(domain: "x", code: 0), serverMessage: "Server says no")

        XCTAssertEqual(sut.view.toasts.last?.message, "Server says no")
        XCTAssertTrue(sut.view.toasts.last?.isError ?? false)
    }

    func test_didFail_withoutServerMessage_showsBanglaFallback() {
        let sut = makeSUT()

        sut.presenter.didFail(URLError(.notConnectedToInternet), serverMessage: nil)

        XCTAssertEqual(sut.view.toasts.last?.message, "ইন্টারনেট সংযোগ নেই। অনুগ্রহ করে আবার চেষ্টা করুন।")
        XCTAssertTrue(sut.view.toasts.last?.isError ?? false)
    }
}

// MARK: - SUT + Mocks

private struct ToastEvent: Equatable {
    let message: String
    let isError: Bool
}

private final class MockUpdateProfileView: UpdateProfileViewProtocol {
    var presenter: UpdateProfilePresenterProtocol?

    var loading: [Bool] = []
    var rendered: [UpdateProfileScreenViewModel] = []
    var toasts: [ToastEvent] = []
    var alerts: [(String, String)] = []
    var success: [(String, String)] = []

    func setLoading(_ isLoading: Bool) { loading.append(isLoading) }
    func render(_ vm: UpdateProfileScreenViewModel) { rendered.append(vm) }
    func showToast(_ message: String, isError: Bool) { toasts.append(.init(message: message, isError: isError)) }
    func showSuccessAndPop(title: String, message: String) { success.append((title, message)) }
    func showAlert(title: String, message: String) { alerts.append((title, message)) }
}

private final class MockUpdateProfileInteractor: UpdateProfileInteractorInputProtocol {
    weak var output: UpdateProfileInteractorOutputProtocol?

    var fetchAvatarCallCount = 0
    var fetchAvatarListCallCount = 0
    var updateCallCount = 0

    func fetchUserAvatar() { fetchAvatarCallCount += 1 }
    func fetchAvatarList() { fetchAvatarListCallCount += 1 }
    func updateProfile(request: UpdateProfileRequest) { updateCallCount += 1 }
}

private final class MockUpdateProfileRouter: UpdateProfileRouterProtocol {
    static func createModule(_ userInfo: UpdateProfileRequest, avatarUrl: String) -> UIViewController { UIViewController() }

    var dismissCallCount = 0
    var presentPickerCallCount = 0

    func dismiss(from view: UpdateProfileViewProtocol?) { dismissCallCount += 1 }

    func presentAvatarPicker(from view: UpdateProfileViewProtocol?, avatars: UserAvatarList, selectedId: Int?, delegate: AvatarPickerViewControllerDelegate) {
        presentPickerCallCount += 1
    }
}

private struct SUT {
    let presenter: UpdateProfilePresenter
    let view: MockUpdateProfileView
    let interactor: MockUpdateProfileInteractor
    let router: MockUpdateProfileRouter
}

private func makeSUT(fullName: String = "User", avatarId: String = "1") -> SUT {
    let userInfo = UpdateProfileRequest(fullName: fullName, gender: "Male", userAvatarId: avatarId)

    let presenter = UpdateProfilePresenter(userInfo: userInfo, avatarUrl: "https://x.com/a.png")
    let view = MockUpdateProfileView()
    let interactor = MockUpdateProfileInteractor()
    let router = MockUpdateProfileRouter()

    presenter.view = view
    presenter.interactor = interactor
    presenter.router = router
    interactor.output = presenter
    view.presenter = presenter

    return SUT(presenter: presenter, view: view, interactor: interactor, router: router)
}

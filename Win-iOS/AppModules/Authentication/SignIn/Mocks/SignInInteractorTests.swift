//
//
//  SignInInteractorTests.swift
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

final class SignInInteractorTests: XCTestCase {
    
    func test_signIn_success_callsPresenterSuccess() async {
        let mockClient = MockNetworkClient()
        let signInData = SignInResponse(
            message: "ok",
            isAuthenticated: true,
            msisdn: "017",
            token: "t",
            earnedPoints: nil, signupPoints: nil, invitationPoints: nil,
            signupImage: nil, appSigninImage: nil,
            appSigninPoints: nil
        )

        mockClient.next = APIResponse(status: 200, message: "OK", data: signInData, error: nil)

        let interactor = SignInInteractor(networkClient: mockClient)
        let presenter = MockInteractorPresenter()
        interactor.presenter = presenter

        interactor.signIn(request: SignInRequest(msisdn: "017", password: "p"), isSaveCredentials: false)

        await presenter.waitForCallback()

        XCTAssertEqual(presenter.successCount, 1)
        XCTAssertEqual(presenter.failCount, 0)
    }

    func test_signIn_nilData_callsPresenterFail() async {
        let mockClient = MockNetworkClient()
        mockClient.next = APIResponse<SignInResponse>(status: 200, message: "OK", data: nil, error: nil)

        let interactor = SignInInteractor(networkClient: mockClient)
        let presenter = MockInteractorPresenter()
        interactor.presenter = presenter

        interactor.signIn(request: SignInRequest(msisdn: "017", password: "p"), isSaveCredentials: false)

        await presenter.waitForCallback()

        XCTAssertEqual(presenter.successCount, 0)
        XCTAssertEqual(presenter.failCount, 1)
    }

    func test_signIn_throw_callsPresenterFail() async {
        let mockClient = MockNetworkClient()
        mockClient.nextError = DummyError()

        let interactor = SignInInteractor(networkClient: mockClient)
        let presenter = MockInteractorPresenter()
        interactor.presenter = presenter

        interactor.signIn(request: SignInRequest(msisdn: "017", password: "p"), isSaveCredentials: false)

        await presenter.waitForCallback()

        XCTAssertEqual(presenter.successCount, 0)
        XCTAssertEqual(presenter.failCount, 1)
    }
}

// MARK: - Mocks

private final class MockNetworkClient: NetworkClientProtocol {

    var next: Any?
    var nextError: Error?

    func post<T: Decodable>(_ request: APIRequest, retries: Int) async throws -> T {
        if let nextError { throw nextError }
        guard let casted = next as? T else {
            throw DummyError()
        }
        return casted
    }
    func get<T>(_ request: APIRequest, retries: Int) async throws -> T where T : Decodable { throw DummyError() }
    func put<T>(_ request: APIRequest, retries: Int) async throws -> T where T : Decodable { throw DummyError() }
    func delete<T>(_ request: APIRequest, retries: Int) async throws -> T where T : Decodable { throw DummyError() }
    func patch<T>(_ request: APIRequest, retries: Int) async throws -> T where T : Decodable { throw DummyError() }
}

private final class MockInteractorPresenter: SignInInteractorOutputProtocol {

    private let exp = XCTestExpectation(description: "callback")
    private(set) var successCount = 0
    private(set) var failCount = 0

    func signInDidSucceed(response: SignInResponse) {
        successCount += 1
        exp.fulfill()
    }

    func signInDidFail(error: Error) {
        failCount += 1
        exp.fulfill()
    }

    func waitForCallback(timeout: TimeInterval = 2.0) async {
        await withCheckedContinuation { continuation in
            XCTWaiter().wait(for: [exp], timeout: timeout)
            continuation.resume()
        }
    }
}

private struct DummyError: LocalizedError {
    var errorDescription: String? { "Network error" }
}

//
//
//  OtpVerificationInteractorTests.swift
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

final class OtpVerificationInteractorTests: XCTestCase {

    func test_verifyOtp_status200_callsSuccess() {
        let exp = expectation(description: "success")
        let mock = MockNetworkClient()
        mock.nextPostResponse = APIResponse<EmptyData>(status: 200, message: "OK", data: EmptyData(), error: nil)

        let interactor = OtpVerificationInteractor(networkClient: mock)
        let presenter = MockOtpOutput { kind in
            if kind == .verifySuccess { exp.fulfill() }
        }
        interactor.presenter = presenter

        interactor.verifyOtp(request: OtpVerificationRequest(msisdn: "88x", password: "123456"))
        wait(for: [exp], timeout: 2)
    }

    func test_verifyOtp_non200_surfacesServerErrorMessage() {
        let exp = expectation(description: "fail")
        let mock = MockNetworkClient()
        mock.nextPostResponse = APIResponse<EmptyData>(status: 400, message: "Bad", data: nil, error: "OTP mismatch")

        let interactor = OtpVerificationInteractor(networkClient: mock)
        let presenter = MockOtpOutput { kind in
            if case .verifyFail(let msg) = kind {
                XCTAssertEqual(msg, "OTP mismatch")
                exp.fulfill()
            }
        }
        interactor.presenter = presenter

        interactor.verifyOtp(request: OtpVerificationRequest(msisdn: "88x", password: "123456"))
        wait(for: [exp], timeout: 2)
    }
}

// MARK: - Mocks

private final class MockNetworkClient: NetworkClientProtocol {

    var nextPostResponse: Any?
    var nextGetResponse: Any?

    func get<T>(_ request: APIRequest, retries: Int) async throws -> T where T : Decodable {
        guard let r = nextGetResponse as? T else { throw DummyError() }
        return r
    }

    func post<T>(_ request: APIRequest, retries: Int) async throws -> T where T : Decodable {
        guard let r = nextPostResponse as? T else { throw DummyError() }
        return r
    }

    func put<T>(_ request: APIRequest, retries: Int) async throws -> T where T : Decodable { throw DummyError() }
    func delete<T>(_ request: APIRequest, retries: Int) async throws -> T where T : Decodable { throw DummyError() }
    func patch<T>(_ request: APIRequest, retries: Int) async throws -> T where T : Decodable { throw DummyError() }
}

private struct DummyError: LocalizedError {
    var errorDescription: String? { "Mock error" }
}

private enum OutputKind: Equatable {
    case verifySuccess
    case verifyFail(String)
}

private final class MockOtpOutput: OtpVerificationInteractorOutputProtocol {
    private let handler: (OutputKind) -> Void
    init(_ handler: @escaping (OutputKind) -> Void) { self.handler = handler }

    func otpVerificationDidSucceed() { handler(.verifySuccess) }
    func otpVerificationDidFail(error: Error) { handler(.verifyFail(error.localizedDescription)) }

    func otpResendDidSucceed() { }
    func otpResendDidFail(error: Error) { }

    func signUpDidSucceed() { }
    func signUpDidFail(error: Error) { }
}

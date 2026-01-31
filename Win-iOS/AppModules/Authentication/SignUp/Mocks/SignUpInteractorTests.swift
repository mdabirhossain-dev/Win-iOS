//
//
//  SignUpInteractorTests.swift
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

final class SignUpInteractorTests: XCTestCase {

    func test_getUserRegistrationStatus_notRegistered_requestsOtp_success() {
        let exp = expectation(description: "completion")

        let mock = MockNetworkClient()
        mock.boolResponse = APIResponse(status: 200, message: "OK", data: false, error: nil)
        mock.emptyResponse = APIResponse(status: 200, message: "OK", data: EmptyData(), error: nil)

        let interactor = SignUpInteractor(networkClient: mock)

        interactor.getUserRegistrationStatus(msisdn: "017") { result in
            switch result {
            case .success(let ok):
                XCTAssertTrue(ok)
            case .failure:
                XCTFail("Expected success")
            }
            exp.fulfill()
        }

        wait(for: [exp], timeout: 2.0)
    }

    func test_getUserRegistrationStatus_emptyData_surfacesServerError() {
        let exp = expectation(description: "completion")

        let mock = MockNetworkClient()
        mock.boolResponse = APIResponse<Bool>(status: 400, message: "Bad Request", data: nil, error: "Invalid msisdn")

        let interactor = SignUpInteractor(networkClient: mock)

        interactor.getUserRegistrationStatus(msisdn: "017") { result in
            switch result {
            case .success:
                XCTFail("Expected failure")
            case .failure(let err):
                XCTAssertEqual(err.localizedDescription, "Invalid msisdn")
            }
            exp.fulfill()
        }

        wait(for: [exp], timeout: 2.0)
    }

    func test_requestOtp_failure_surfacesServerError() {
        let exp = expectation(description: "completion")

        let mock = MockNetworkClient()
        mock.emptyResponse = APIResponse(status: 429, message: "Too many requests", data: nil, error: "OTP blocked")

        let interactor = SignUpInteractor(networkClient: mock)

        interactor.requestOTP(msisdn: "017") { result in
            switch result {
            case .success:
                XCTFail("Expected failure")
            case .failure(let err):
                XCTAssertEqual(err.localizedDescription, "OTP blocked")
            }
            exp.fulfill()
        }

        wait(for: [exp], timeout: 2.0)
    }
}

// MARK: - Mock Network Client

private final class MockNetworkClient: NetworkClientProtocol {

    var boolResponse: APIResponse<Bool>?
    var emptyResponse: APIResponse<EmptyData>?
    var nextError: Error?

    func get<T>(_ request: APIRequest, retries: Int) async throws -> T where T : Decodable {
        if let nextError { throw nextError }
        if T.self == APIResponse<Bool>.self, let r = boolResponse as? T { return r }
        if T.self == APIResponse<EmptyData>.self, let r = emptyResponse as? T { return r }
        throw DummyError()
    }

    func post<T>(_ request: APIRequest, retries: Int) async throws -> T where T : Decodable { throw DummyError() }
    func put<T>(_ request: APIRequest, retries: Int) async throws -> T where T : Decodable { throw DummyError() }
    func delete<T>(_ request: APIRequest, retries: Int) async throws -> T where T : Decodable { throw DummyError() }
    func patch<T>(_ request: APIRequest, retries: Int) async throws -> T where T : Decodable { throw DummyError() }
}

private struct DummyError: LocalizedError {
    var errorDescription: String? { "Mock decode error" }
}

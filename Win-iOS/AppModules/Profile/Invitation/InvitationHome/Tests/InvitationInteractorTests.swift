//
//
//  InvitationInteractorTests.swift
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

final class InvitationInteractorTests: XCTestCase {

    func test_fetchInvitationInfo_onSuccess_callsFetched() async {
        let network = NetworkClientFake()
        let output = RecordingInvitationOutput()
        let sut = InvitationInteractor(networkClient: network)
        sut.output = output

        let response = APIResponse<InvitationResponse>(
            status: 200,
            message: "OK",
            data: InvitationResponse(
                invitationMappingID: nil,
                msisdn: nil,
                invitationCode: "ABC",
                codeGenerationDate: nil,
                invitedBy: nil,
                joinDate: nil,
                joinDateBengali: nil,
                point: 7
            ),
            error: nil
        )

        network.getHandler = { _, _ in response }

        sut.fetchInvitationInfo()

        await waitUntil { output.fetchedCount == 1 }

        XCTAssertEqual(output.fetchedCount, 1)
        XCTAssertEqual(output.failedMessages.count, 0)
        XCTAssertEqual(output.fetchedResponse?.invitationCode, "ABC")
    }

    func test_fetchInvitationInfo_whenNoData_callsFailed_withMessageFallback() async {
        let network = NetworkClientFake()
        let output = RecordingInvitationOutput()
        let sut = InvitationInteractor(networkClient: network)
        sut.output = output

        let response = APIResponse<InvitationResponse>(
            status: 200,
            message: "No data",
            data: nil,
            error: nil
        )

        network.getHandler = { _, _ in response }

        sut.fetchInvitationInfo()

        await waitUntil { output.failedMessages.count == 1 }

        XCTAssertEqual(output.fetchedCount, 0)
        XCTAssertEqual(output.failedMessages.count, 1)
        XCTAssertEqual(output.failedMessages[0], "No data")
    }

    func test_fetchInvitationInfo_onThrow_callsFailed_withErrorDescription() async {
        let network = NetworkClientFake()
        let output = RecordingInvitationOutput()
        let sut = InvitationInteractor(networkClient: network)
        sut.output = output

        network.getHandler = { _, _ in
            throw NSError(domain: "x", code: 1, userInfo: [NSLocalizedDescriptionKey: "Boom"])
        }

        sut.fetchInvitationInfo()

        await waitUntil { output.failedMessages.count == 1 }

        XCTAssertEqual(output.fetchedCount, 0)
        XCTAssertEqual(output.failedMessages, ["Boom"])
    }
}

// MARK: - Output Recorder

private final class RecordingInvitationOutput: InvitationInteractorOutput {

    private(set) var fetchedCount = 0
    private(set) var fetchedResponse: InvitationResponse?
    private(set) var failedMessages: [String] = []

    func invitationInfoFetched(_ response: InvitationResponse) {
        fetchedCount += 1
        fetchedResponse = response
    }

    func invitationInfoFailed(_ message: String) {
        failedMessages.append(message)
    }
}

// MARK: - Async wait helper

private extension XCTestCase {
    func waitUntil(
        timeout: TimeInterval = 1.0,
        _ condition: @escaping () -> Bool
    ) async {
        let start = Date()
        while !condition() && Date().timeIntervalSince(start) < timeout {
            try? await Task.sleep(nanoseconds: 20_000_000) // 20ms
        }
    }
}

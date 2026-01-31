//
//
//  RedeemScoreInteractorTests.swift
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

final class RedeemScoreInteractorTests: XCTestCase {

    func test_fetchRedeemScore_onSuccess_callsFetched() async throws {
        let network = NetworkClientFake()
        let output = RecordingRedeemScoreOutput()
        let sut = RedeemScoreInteractor(networkClient: network)
        sut.output = output

        let data: RedeemScore = try TestJSON.makeRedeemScore(totalScore: 5, giftVouchersCount: 0, cashbackCount: 0)

        let response = APIResponse<RedeemScore>(
            status: 200,
            message: "OK",
            data: data,
            error: nil
        )

        network.getHandler = { _, _ in response }

        sut.fetchRedeemScore()
        await waitUntil { output.fetchedCount == 1 || output.failedMessages.count == 1 }

        XCTAssertEqual(output.fetchedCount, 1)
        XCTAssertEqual(output.failedMessages.count, 0)
    }

    func test_fetchRedeemScore_whenNoData_callsFailed_withMessageOrFallback() async {
        let network = NetworkClientFake()
        let output = RecordingRedeemScoreOutput()
        let sut = RedeemScoreInteractor(networkClient: network)
        sut.output = output

        let response = APIResponse<RedeemScore>(
            status: 200,
            message: "No data",
            data: nil,
            error: nil
        )

        network.getHandler = { _, _ in response }

        sut.fetchRedeemScore()
        await waitUntil { output.failedMessages.count == 1 }

        XCTAssertEqual(output.fetchedCount, 0)
        XCTAssertEqual(output.failedMessages.first, "No data")
    }

    func test_fetchRedeemScore_onThrow_callsFailed_withErrorDescription() async {
        let network = NetworkClientFake()
        let output = RecordingRedeemScoreOutput()
        let sut = RedeemScoreInteractor(networkClient: network)
        sut.output = output

        network.getHandler = { _, _ in
            throw NSError(domain: "x", code: 1, userInfo: [NSLocalizedDescriptionKey: "Boom"])
        }

        sut.fetchRedeemScore()
        await waitUntil { output.failedMessages.count == 1 }

        XCTAssertEqual(output.failedMessages, ["Boom"])
    }
}

// MARK: - Output Recorder

private final class RecordingRedeemScoreOutput: RedeemScoreInteractorOutput {

    private(set) var fetchedCount = 0
    private(set) var lastData: RedeemScore?
    private(set) var failedMessages: [String] = []

    func redeemScoreFetched(_ data: RedeemScore) {
        fetchedCount += 1
        lastData = data
    }

    func redeemScoreFailed(_ message: String) {
        failedMessages.append(message)
    }
}

// MARK: - Network Fake (uses YOUR protocol)

private final class NetworkClientFake: NetworkClientProtocol {

    var getHandler: ((APIRequest, Int) async throws -> Any)?

    func get<T: Decodable>(_ request: APIRequest, retries: Int) async throws -> T {
        guard let value = try await getHandler?(request, retries) else {
            fatalError("NetworkClientFake.getHandler not set")
        }
        guard let typed = value as? T else {
            fatalError("NetworkClientFake returned wrong type. Expected \(T.self), got \(type(of: value))")
        }
        return typed
    }

    func post<T: Decodable>(_ request: APIRequest, retries: Int) async throws -> T { fatalError("Not needed") }
    func put<T: Decodable>(_ request: APIRequest, retries: Int) async throws -> T { fatalError("Not needed") }
    func delete<T: Decodable>(_ request: APIRequest, retries: Int) async throws -> T { fatalError("Not needed") }
    func patch<T: Decodable>(_ request: APIRequest, retries: Int) async throws -> T { fatalError("Not needed") }
}

// MARK: - Async Wait Helper

private extension XCTestCase {
    func waitUntil(timeout: TimeInterval = 1.0, _ condition: @escaping () -> Bool) async {
        let start = Date()
        while !condition() && Date().timeIntervalSince(start) < timeout {
            try? await Task.sleep(nanoseconds: 20_000_000) // 20ms
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

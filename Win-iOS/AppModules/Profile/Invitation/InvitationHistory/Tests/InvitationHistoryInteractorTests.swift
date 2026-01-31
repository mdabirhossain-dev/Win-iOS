//
//
//  InvitationHistoryInteractorTests.swift
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

//final class InvitationHistoryInteractorOutputRecorder: InvitationHistoryInteractorOutput {
//
//    var onFetched: ((InvitationList?) -> Void)?
//    var onFailed: ((String) -> Void)?
//
//    func invitationHistoryFetched(_ list: InvitationList?) {
//        onFetched?(list)
//    }
//
//    func invitationHistoryFailed(_ message: String) {
//        onFailed?(message)
//    }
//}
//
//final class InvitationHistoryInteractorTests: XCTestCase {
//
//    func test_fetchInvitationHistory_success_callsFetched() async {
//        let network = NetworkClientFake()
//        let output = InvitationHistoryInteractorOutputRecorder()
//
//        let exp = expectation(description: "invitationHistoryFetched called")
//
//        output.onFetched = { list in
//            XCTAssertEqual(list?.count, 1)
//            XCTAssertEqual(list?.first?.msisdn, "8801712345678")
//            exp.fulfill()
//        }
//
//        network.getHandler = { req, retries in
//            XCTAssertEqual(req.path, APIConstants.invitationHistoryURL)
//            XCTAssertEqual(req.method, .get)
//
//            let item = InvitationResponse(
//                invitationMappingID: 1,
//                msisdn: "8801712345678",
//                invitationCode: nil,
//                codeGenerationDate: nil,
//                invitedBy: nil,
//                joinDate: nil,
//                joinDateBengali: "১২ জানুয়ারি, ২০২৬",
//                point: 10
//            )
//
//            let api = APIResponse<InvitationList>(
//                status: 200,
//                message: nil,
//                data: [item],
//                error: nil
//            )
//
//            return api
//        }
//
//        // Your production interactor should look like your ProfileInteractor demo:
//        // init(networkClient: NetworkClientProtocol), output set, then fetchInvitationHistory()
//        let interactor = InvitationHistoryInteractor(networkClient: network)
//        interactor.output = output
//
//        interactor.fetchInvitationHistory()
//
//        await fulfillment(of: [exp], timeout: 1.0)
//    }
//
//    func test_fetchInvitationHistory_whenDataNil_callsFailed() async {
//        let network = NetworkClientFake()
//        let output = InvitationHistoryInteractorOutputRecorder()
//
//        let exp = expectation(description: "invitationHistoryFailed called")
//
//        output.onFailed = { message in
//            XCTAssertFalse(message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
//            exp.fulfill()
//        }
//
//        network.getHandler = { req, retries in
//            let api = APIResponse<InvitationList>(
//                status: 200,
//                message: "No data",
//                data: nil,
//                error: nil
//            )
//            return api
//        }
//
//        let interactor = InvitationHistoryInteractor(networkClient: network)
//        interactor.output = output
//
//        interactor.fetchInvitationHistory()
//
//        await fulfillment(of: [exp], timeout: 1.0)
//    }
//
//    func test_fetchInvitationHistory_networkThrows_callsFailed() async {
//        let network = NetworkClientFake()
//        let output = InvitationHistoryInteractorOutputRecorder()
//
//        let exp = expectation(description: "invitationHistoryFailed called")
//
//        output.onFailed = { message in
//            XCTAssertFalse(message.isEmpty)
//            exp.fulfill()
//        }
//
//        network.getHandler = { _, _ in
//            throw APIError.server(statusCode: 500)
//        }
//
//        let interactor = InvitationHistoryInteractor(networkClient: network)
//        interactor.output = output
//
//        interactor.fetchInvitationHistory()
//
//        await fulfillment(of: [exp], timeout: 1.0)
//    }
//}

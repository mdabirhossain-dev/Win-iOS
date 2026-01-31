//
//
//  PasswordResetInteractorTests.swift
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

//final class PasswordResetInteractorTests: XCTestCase {
//
//    func test_checkRegistrationAndRequestOTP_whenNotRegistered_callsFailedWithBanglaMessage() async {
//        let network = NetworkClientFake()
//        let output = RecordingPasswordResetOutput()
//
//        // First GET => status check => data false
//        network.getHandler = { request, retries in
//            let res = APIResponse<Bool>(status: 200, message: nil, data: false, error: nil)
//            return res
//        }
//
//        let sut = PasswordResetInteractor(networkClient: network)
//        sut.output = output
//
//        sut.checkRegistrationAndRequestOTP(msisdn: "01711111111")
//        await waitUntil { output.failedMessages.count == 1 }
//
//        XCTAssertEqual(output.failedMessages.first, "আপনি রেজিস্টার্ড ইউজার নন")
//        XCTAssertTrue(output.successMSISDNs.isEmpty)
//    }
//
//    func test_checkRegistrationAndRequestOTP_whenRegisteredAndOTP200_callsSucceeded() async {
//        let network = NetworkClient()
//        let output = RecordingPasswordResetOutput()
//
//        var call = 0
//        network.getHandler = { request in
//            call += 1
//
//            if call == 1 {
//                // registration status
//                return APIResponse<Bool>(status: 200, message: nil, data: true, error: nil)
//            } else {
//                // otp request
//                return APIResponse<EmptyData>(status: 200, message: "OK", data: EmptyData(), error: nil)
//            }
//        }
//
//        let sut = PasswordResetInteractor(networkClient: network)
//        sut.output = output
//
//        sut.checkRegistrationAndRequestOTP(msisdn: "01711111111")
//        await waitUntil { output.successMSISDNs.count == 1 || output.failedMessages.count == 1 }
//
//        XCTAssertEqual(output.successMSISDNs, ["01711111111"])
//        XCTAssertTrue(output.failedMessages.isEmpty)
//    }
//
//    func test_checkRegistrationAndRequestOTP_whenOTPNot200_callsFailedWithServerMessageOrError() async {
//        let network = NetworkClientFake()
//        let output = RecordingPasswordResetOutput()
//
//        var call = 0
//        network.getHandler = { request, retries in
//            call += 1
//
//            if call == 1 {
//                return APIResponse<Bool>(status: 200, message: nil, data: true, error: nil)
//            } else {
//                return APIResponse<EmptyData>(status: 500, message: "Failed", data: nil, error: nil)
//            }
//        }
//
//        let sut = PasswordResetInteractor(networkClient: network)
//        sut.output = output
//
//        sut.checkRegistrationAndRequestOTP(msisdn: "01711111111")
//        await waitUntil { output.failedMessages.count == 1 }
//
//        XCTAssertEqual(output.failedMessages.first, "Failed")
//        XCTAssertTrue(output.successMSISDNs.isEmpty)
//    }
//
//    func test_checkRegistrationAndRequestOTP_whenOTPNot200_andNoMessage_usesFallbackBanglaMessage() async {
//        let network = NetworkClientFake()
//        let output = RecordingPasswordResetOutput()
//
//        var call = 0
//        network.getHandler = { request, retries in
//            call += 1
//
//            if call == 1 {
//                return APIResponse<Bool>(status: 200, message: nil, data: true, error: nil)
//            } else {
//                // No message, no error -> should fallback
//                return APIResponse<EmptyData>(status: 500, message: nil, data: nil, error: nil)
//            }
//        }
//
//        let sut = PasswordResetInteractor(networkClient: network)
//        sut.output = output
//
//        sut.checkRegistrationAndRequestOTP(msisdn: "01711111111")
//        await waitUntil { output.failedMessages.count == 1 }
//
//        XCTAssertEqual(output.failedMessages.first, "OTP পাঠানো ব্যর্থ হয়েছে")
//        XCTAssertTrue(output.successMSISDNs.isEmpty)
//    }
//
//    func test_checkRegistrationAndRequestOTP_whenNetworkThrows_callsFailedWithFallbackNetworkMessage() async {
//        let network = NetworkClientFake()
//        let output = RecordingPasswordResetOutput()
//
//        network.getHandler = { request, retries in
//            throw NSError(domain: "x", code: 1, userInfo: [NSLocalizedDescriptionKey: "Boom"])
//        }
//
//        let sut = PasswordResetInteractor(networkClient: network)
//        sut.output = output
//
//        sut.checkRegistrationAndRequestOTP(msisdn: "01711111111")
//        await waitUntil { output.failedMessages.count == 1 }
//
//        XCTAssertEqual(output.failedMessages.first, "নেটওয়ার্ক সমস্যা। আবার চেষ্টা করুন")
//        XCTAssertTrue(output.successMSISDNs.isEmpty)
//    }
//}
//
//// MARK: - Output Recorder
//
//private final class RecordingPasswordResetOutput: PasswordResetInteractorOutput {
//
//    private(set) var successMSISDNs: [String] = []
//    private(set) var failedMessages: [String] = []
//
//    func otpRequestSucceeded(msisdn: String) {
//        successMSISDNs.append(msisdn)
//    }
//
//    func otpRequestFailed(_ message: String) {
//        failedMessages.append(message)
//    }
//}
//
//// MARK: - Async Wait Helper
//
//private extension XCTestCase {
//    func waitUntil(timeout: TimeInterval = 1.0, _ condition: @escaping () -> Bool) async {
//        let start = Date()
//        while !condition() && Date().timeIntervalSince(start) < timeout {
//            try? await Task.sleep(nanoseconds: 20_000_000) // 20ms
//        }
//        XCTAssertTrue(condition(), "Condition not met within \(timeout)s")
//    }
//}

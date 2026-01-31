//
//
//  PasswordResetInteractor.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 12/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//


import Foundation

final class PasswordResetInteractor: PasswordResetInteractorProtocol {

    weak var output: PasswordResetInteractorOutput?

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient = NetworkClient()) {
        self.networkClient = networkClient
    }

    func checkRegistrationAndRequestOTP(msisdn: String) {
        Task { [weak self] in
            guard let self else { return }

            do {
                // 1) Check registration
                var statusReq = APIRequest(path: APIConstants.userRegistrationStatusURL(msisdn: msisdn))
                statusReq.method = .get

                let statusRes: APIResponse<Bool> = try await networkClient.get(statusReq)
                let isRegistered = statusRes.data ?? false

                guard isRegistered else {
                    await MainActor.run {
                        self.output?.otpRequestFailed("আপনি রেজিস্টার্ড ইউজার নন")
                    }
                    return
                }

                // 2) Request OTP (forgotPassword)
                var otpReq = APIRequest(path: APIConstants.otpRequestURL(msisdn: msisdn, otpEvent: .forgotPassword))
                otpReq.method = .get

                let otpRes: APIResponse<EmptyData> = try await networkClient.get(otpReq)

                await MainActor.run {
                    if otpRes.status == 200 {
                        self.output?.otpRequestSucceeded(msisdn: msisdn)
                    } else {
                        self.output?.otpRequestFailed(otpRes.message ?? otpRes.error ?? "OTP পাঠানো ব্যর্থ হয়েছে")
                    }
                }

            } catch {
                await MainActor.run {
                    self.output?.otpRequestFailed("নেটওয়ার্ক সমস্যা। আবার চেষ্টা করুন")
                }
            }
        }
    }
}

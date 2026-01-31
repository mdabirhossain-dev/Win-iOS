//
//
//  OtpVerificationInteractor.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 14/10/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//

import Foundation

// MARK: - Interactor
final class OtpVerificationInteractor: OtpVerificationInteractorInputProtocol {

    weak var presenter: OtpVerificationInteractorOutputProtocol?
    private let networkClient: NetworkClientProtocol

    init(networkClient: NetworkClientProtocol = NetworkClient()) {
        self.networkClient = networkClient
    }

    func verifyOtp(request: OtpVerificationRequest) {
        Task { [weak self] in
            guard let self else { return }

            var req = APIRequest(path: APIConstants.otpVerificationURL)
            req.method = .post
            req.body = request

            do {
                let response: APIResponse<EmptyData> = try await self.networkClient.post(req, retries: 0)

                await MainActor.run {
                    if response.status == 200 {
                        self.presenter?.otpVerificationDidSucceed()
                    } else {
                        let msg = response.error ?? response.message ?? "OTP verification failed"
                        let err = NSError(
                            domain: "OtpVerificationInteractorError",
                            code: response.status,
                            userInfo: [NSLocalizedDescriptionKey: msg]
                        )
                        self.presenter?.otpVerificationDidFail(error: err)
                    }
                }
            } catch {
                await MainActor.run {
                    self.presenter?.otpVerificationDidFail(error: error)
                }
            }
        }
    }

    func resendOtp(request: ResendOtpRequest) {
        Task { [weak self] in
            guard let self else { return }

            var req = APIRequest(path: APIConstants.otpRequestURL(msisdn: request.msisdn, otpEvent: request.otpEvent))
            req.method = .get

            do {
                let response: APIResponse<EmptyData> = try await self.networkClient.get(req, retries: 0)

                await MainActor.run {
                    if response.status == 200 {
                        self.presenter?.otpResendDidSucceed()
                    } else {
                        let msg = response.error ?? response.message ?? "OTP resend failed"
                        let err = NSError(
                            domain: "OtpResendInteractorError",
                            code: response.status,
                            userInfo: [NSLocalizedDescriptionKey: msg]
                        )
                        self.presenter?.otpResendDidFail(error: err)
                    }
                }
            } catch {
                await MainActor.run {
                    self.presenter?.otpResendDidFail(error: error)
                }
            }
        }
    }

    func signUp(request: SignUpRequest) {
        Task { [weak self] in
            guard let self else { return }

            var req = APIRequest(path: APIConstants.signUpURL)
            req.method = .post
            req.body = request

            do {
                let response: APIResponse<SignUpResponse> = try await self.networkClient.post(req, retries: 0)

                await MainActor.run {
                    if response.status == 200, response.data != nil {
                        self.presenter?.signUpDidSucceed()
                    } else {
                        let msg = response.error ?? response.message ?? "Sign up failed"
                        let err = NSError(
                            domain: "SignUpInteractorError",
                            code: response.status,
                            userInfo: [NSLocalizedDescriptionKey: msg]
                        )
                        self.presenter?.signUpDidFail(error: err)
                    }
                }
            } catch {
                await MainActor.run {
                    self.presenter?.signUpDidFail(error: error)
                }
            }
        }
    }
}

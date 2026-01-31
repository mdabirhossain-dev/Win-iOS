//
//
//  SignUpInteractor.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 15/10/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import Foundation

// MARK: - Interactor
class SignUpInteractor: SignUpInteractorInputProtocol {

    weak var presenter: SignUpInteractorOutputProtocol?
    private let networkClient: NetworkClientProtocol

    init(networkClient: NetworkClientProtocol = NetworkClient()) {
        self.networkClient = networkClient
    }

    func getUserRegistrationStatus(msisdn: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        Task {
            var req = APIRequest(path: APIConstants.userRegistrationStatusURL(msisdn: msisdn))
            req.method = .get

            do {
                let response: APIResponse<Bool> = try await networkClient.get(req, retries: 0)

                await MainActor.run {
                    // ✅ If server didn't send data, surface server message/error
                    guard let isRegistered = response.data else {
                        let msg = response.error ?? response.message ?? "Request failed"
                        let error = NSError(
                            domain: "UserRegistrationStatusInteractorError",
                            code: response.status,
                            userInfo: [NSLocalizedDescriptionKey: msg]
                        )
                        Log.info(error)
                        completion(.failure(error))
                        return
                    }

                    if isRegistered == false {
                        self.requestOTP(msisdn: msisdn) { result in
                            switch result {
                            case .success(let ok):
                                completion(.success(ok))
                            case .failure(let err):
                                completion(.failure(err))
                            }
                        }
                    } else {
                        let error = NSError(
                            domain: "UserRegistrationStatusInteractorError",
                            code: -1,
                            userInfo: [NSLocalizedDescriptionKey: "Already registered user"]
                        )
                        Log.info(error)
                        completion(.failure(error))
                    }
                }
            } catch {
                await MainActor.run {
                    Log.info(error)
                    completion(.failure(error))
                }
            }
        }
    }

    func requestOTP(msisdn: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        Task { [weak self] in
            guard let self else { return }

            var req = APIRequest(path: APIConstants.otpRequestURL(msisdn: msisdn, otpEvent: .signUp))
            req.method = .get

            do {
                let response: APIResponse<EmptyData> = try await self.networkClient.get(req, retries: 0)

                await MainActor.run {
                    if response.status == 200 {
                        completion(.success(true))
                    } else {
                        let msg = response.error ?? response.message ?? "OTP request failed"
                        let error = NSError(
                            domain: "OTPRequestStatusInteractorError",
                            code: response.status,
                            userInfo: [NSLocalizedDescriptionKey: msg]
                        )
                        Log.info(error)
                        completion(.failure(error))
                    }
                }
            } catch {
                await MainActor.run {
                    Log.info(error)
                    completion(.failure(error))
                }
            }
        }
    }

    func signUpWithApple(request: ResendOtpRequest) { }
    func signUpWithGoogle(request: ResendOtpRequest) { }
    func signUpWithFacebook(request: ResendOtpRequest) { }
}

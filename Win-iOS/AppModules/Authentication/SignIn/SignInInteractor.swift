//
//
//  SignInInteractor.swift
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
private enum SignInInteractorError: LocalizedError {
    case emptyResponse

    var errorDescription: String? {
        switch self {
        case .emptyResponse:
            return "সার্ভার থেকে সঠিক রেসপন্স পাওয়া যায়নি"
        }
    }
}

class SignInInteractor: SignInInteractorInputProtocol {

    weak var presenter: SignInInteractorOutputProtocol?
    private let networkClient: NetworkClientProtocol

    init(networkClient: NetworkClientProtocol = NetworkClient()) {
        self.networkClient = networkClient
    }

    func signIn(request: SignInRequest, isSaveCredentials: Bool) {
        Task { [weak self] in
            guard let self else { return }

            var req = APIRequest(path: APIConstants.signInURL)
            req.method = .post
            req.body = request

            do {
                // ✅ Your NetworkClient returns decoded generic type directly
                let response: APIResponse<SignInResponse> = try await self.networkClient.post(req, retries: 0)

                await MainActor.run {
                    guard let data = response.data else {
                        self.presenter?.signInDidFail(error: SignInInteractorError.emptyResponse)
                        return
                    }

                    if isSaveCredentials {
                        KeychainManager.shared.saveAuth(msisdn: request.msisdn,
                                                        password: request.password,
                                                        token: data.token)
                    } else {
                        KeychainManager.shared.saveAuth(token: data.token)
                    }

                    self.presenter?.signInDidSucceed(response: data)
                }
            } catch {
                await MainActor.run {
                    self.presenter?.signInDidFail(error: error)
                }
            }
        }
    }

    func signInWithApple(request: ResendOtpRequest) { }
    func signInWithGoogle(request: ResendOtpRequest) { }
    func signInWithFacebook(request: ResendOtpRequest) { }
}

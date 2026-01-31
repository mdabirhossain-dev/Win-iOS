//
//
//  NewPasswordInteractor.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 12/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//



import Foundation

final class NewPasswordInteractor: NewPasswordInteractorProtocol {

    weak var output: NewPasswordInteractorOutput?

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient = NetworkClient()) {
        self.networkClient = networkClient
    }

    func setPassword(request: ResetPasswordRequest) {
        Task { [weak self] in
            guard let self else { return }

            var req = APIRequest(path: APIConstants.updatePasswordURL)
            req.method = .post
            req.body = request

            do {
                let response: APIResponse<EmptyData> = try await self.networkClient.post(req)
                await MainActor.run {
                    if response.status == 200 {
                        self.output?.setPasswordSucceeded()
                    } else {
                        self.output?.setPasswordFailed(response.message ?? response.error ?? "পাসওয়ার্ড আপডেট ব্যর্থ হয়েছে")
                    }
                }
            } catch {
                await MainActor.run {
                    self.output?.setPasswordFailed("পাসওয়ার্ড আপডেট ব্যর্থ হয়েছে")
                }
            }
        }
    }
}

//
//
//  ProfileInteractor.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 11/11/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import Foundation

final class ProfileInteractor: ProfileInteractorInputProtocol {

    weak var output: ProfileInteractorOutputProtocol?
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient = NetworkClient()) {
        self.networkClient = networkClient
    }

    func fetchUserSummary() {
        Task { [weak self] in
            guard let self else { return }

            var req = APIRequest(path: APIConstants.userSummeryURL)
            req.method = .get

            do {
                let response: APIResponse<UserSummaryResponse> = try await self.networkClient.get(req)

                await MainActor.run {
                    if let data = response.data {
                        self.output?.didReceiveUserSummary(data)
                        return
                    }

                    // ✅ show real server error if present, otherwise Bangla fallback
                    let msg = (response.error?.trimmingCharacters(in: .whitespacesAndNewlines)).flatMap { $0.isEmpty ? nil : $0 }
                        ?? (response.message?.trimmingCharacters(in: .whitespacesAndNewlines)).flatMap { $0.isEmpty ? nil : $0 }
                        ?? "প্রোফাইল তথ্য লোড করা যায়নি"

                    let error = NSError(
                        domain: "ProfileInteractorError",
                        code: response.status,
                        userInfo: [NSLocalizedDescriptionKey: msg]
                    )
                    self.output?.didFail(error)
                }
            } catch {
                await MainActor.run {
                    self.output?.didFail(error)
                }
            }
        }
    }
}

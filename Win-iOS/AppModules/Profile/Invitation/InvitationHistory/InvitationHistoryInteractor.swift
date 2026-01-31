//
//
//  InvitationHistoryInteractor.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 30/12/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import Foundation

final class InvitationHistoryInteractor: InvitationHistoryInteractorInput {

    weak var output: InvitationHistoryInteractorOutput?
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient = NetworkClient()) {
        self.networkClient = networkClient
    }

    func fetchInvitationHistory() {
        Task { [weak self] in
            guard let self else { return }

            var req = APIRequest(path: APIConstants.invitationHistoryURL)
            req.method = .get

            do {
                let response: APIResponse<InvitationList> = try await self.networkClient.get(req)

                await MainActor.run {
                    if let data = response.data {
                        self.output?.invitationHistoryFetched(data)
                        return
                    }

                    // ✅ prefer server error/message, fallback Bangla
                    let msg = (response.error?.trimmingCharacters(in: .whitespacesAndNewlines)).flatMap { $0.isEmpty ? nil : $0 }
                    ?? (response.message?.trimmingCharacters(in: .whitespacesAndNewlines)).flatMap { $0.isEmpty ? nil : $0 }
                    ?? "ইনভাইট হিস্ট্রি লোড করা যায়নি"

                    self.output?.invitationHistoryFailed(msg)
                }
            } catch {
                await MainActor.run {
                    self.output?.invitationHistoryFailed(error.localizedDescription)
                }
            }
        }
    }
}

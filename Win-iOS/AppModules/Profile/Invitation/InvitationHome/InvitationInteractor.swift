//
//
//  InvitationInteractor.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 13/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//



import Foundation

final class InvitationInteractor: InvitationInteractorInputProtocol {

    weak var output: InvitationInteractorOutput?
    private let networkClient: NetworkClientProtocol

    init(networkClient: NetworkClientProtocol = NetworkClient()) {
        self.networkClient = networkClient
    }

    func fetchInvitationInfo() {
        Task { [weak self] in
            guard let self else { return }

            var req = APIRequest(path: APIConstants.invitationCodeURL)
            req.method = .get

            do {
                let response: APIResponse<InvitationResponse> = try await self.networkClient.get(req, retries: 0)

                await MainActor.run {
                    if let data = response.data {
                        self.output?.invitationInfoFetched(data)
                        return
                    }

                    let msg =
                    (response.error?.trimmingCharacters(in: .whitespacesAndNewlines)).flatMap { $0.isEmpty ? nil : $0 }
                    ?? (response.message?.trimmingCharacters(in: .whitespacesAndNewlines)).flatMap { $0.isEmpty ? nil : $0 }
                    ?? "ইনভাইট তথ্য লোড করা যায়নি"

                    self.output?.invitationInfoFailed(msg)
                }
            } catch {
                await MainActor.run {
                    self.output?.invitationInfoFailed(error.localizedDescription)
                }
            }
        }
    }
}
//
//
//  RedeemScoreInteractor.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 13/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//



import Foundation

final class RedeemScoreInteractor: RedeemScoreInteractorInputProtocol {

    weak var output: RedeemScoreInteractorOutput?
    private let networkClient: NetworkClientProtocol

    init(networkClient: NetworkClientProtocol = NetworkClient()) {
        self.networkClient = networkClient
    }

    func fetchRedeemScore() {
        Task { [weak self] in
            guard let self else { return }

            var req = APIRequest(path: APIConstants.getCouponListURL)
            req.method = .get

            do {
                let response: APIResponse<RedeemScore> = try await self.networkClient.get(req, retries: 0)

                await MainActor.run {
                    if let data = response.data {
                        self.output?.redeemScoreFetched(data)
                        return
                    }

                    let msg =
                    (response.error?.trimmingCharacters(in: .whitespacesAndNewlines)).flatMap { $0.isEmpty ? nil : $0 }
                    ?? (response.message?.trimmingCharacters(in: .whitespacesAndNewlines)).flatMap { $0.isEmpty ? nil : $0 }
                    ?? "রিডিম স্কোর তথ্য লোড করা যায়নি"

                    self.output?.redeemScoreFailed(msg)
                }
            } catch {
                await MainActor.run {
                    self.output?.redeemScoreFailed(error.localizedDescription)
                }
            }
        }
    }
}
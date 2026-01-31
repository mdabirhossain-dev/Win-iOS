//
//
//  TotalScoreEntity.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 18/11/25.
//  Contact me if anything is needed:
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import Foundation

final class TotalScoreInteractor: TotalScoreInteractorInputProtocol {

    weak var output: TotalScoreInteractorOutputProtocol?
    private let networkClient: NetworkClientProtocol

    init(networkClient: NetworkClientProtocol = NetworkClient()) {
        self.networkClient = networkClient
    }

    func getScoreDetails() {
        Task { [weak self] in
            guard let self else { return }

            var req = APIRequest(path: APIConstants.totalScoreURL)
            req.method = .get

            do {
                let response: APIResponse<CampaignWiseScores> = try await self.networkClient.get(req, retries: 0)

                await MainActor.run {
                    // ✅ Server-level failure
                    if response.status != 200 {
                        let serverMsg = (response.error ?? response.message ?? "")
                            .trimmingCharacters(in: .whitespacesAndNewlines)

                        let fallback = "সার্ভার ত্রুটি হয়েছে (\(response.status))"
                        let err = NSError(
                            domain: "TotalScoreServer",
                            code: response.status,
                            userInfo: [NSLocalizedDescriptionKey: serverMsg.isEmpty ? fallback : serverMsg]
                        )
                        self.output?.didFail(err)
                        return
                    }

                    guard let data = response.data else {
                        let msg = (response.error ?? response.message ?? "ডেটা পাওয়া যায়নি")
                            .trimmingCharacters(in: .whitespacesAndNewlines)

                        let err = NSError(
                            domain: "TotalScore",
                            code: -1,
                            userInfo: [NSLocalizedDescriptionKey: msg.isEmpty ? "ডেটা পাওয়া যায়নি" : msg]
                        )
                        self.output?.didFail(err)
                        return
                    }

                    self.output?.didReceiveScoreDetails(data)
                }
            } catch {
                await MainActor.run { self.output?.didFail(error) }
            }
        }
    }
}

//final class TotalScoreInteractor: TotalScoreInteractorInputProtocol {
//    weak var output: TotalScoreInteractorOutputProtocol?
//    private let networkClient: NetworkClient
//
//    init(networkClient: NetworkClient = NetworkClient()) {
//        self.networkClient = networkClient
//    }
//
//    func getScoreDetails() {
//        Task { [weak self] in
//            guard let self else { return }
//            var req = APIRequest(path: APIConstants.totalScoreURL)
//            req.method = .get
//            do {
//                let response: APIResponse<CampaignWiseScores> = try await self.networkClient.get(req)
//                if let data = response.data {
//                    await MainActor.run { self.output?.didReceiveScoreDetails(data) }
//                } else {
//                    let error = NSError(domain: "TotalPointInteractorError",
//                                        code: -1,
//                                        userInfo: [NSLocalizedDescriptionKey: "No data received"])
//                    await MainActor.run { self.output?.didFail(error) }
//                }
//            } catch {
//                await MainActor.run { self.output?.didFail(error) }
//            }
//        }
//    }
//}

//
//
//  TotalPointInteractor.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 18/11/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import Foundation

final class TotalPointInteractor: TotalPointInteractorInputProtocol {

    weak var output: TotalPointInteractorOutputProtocol?
    private let networkClient: NetworkClientProtocol

    init(networkClient: NetworkClientProtocol = NetworkClient()) {
        self.networkClient = networkClient
    }

    func getScoreDetails() {
        Task { [weak self] in
            guard let self else { return }

            var req = APIRequest(path: APIConstants.totalPointURL)
            req.method = .get

            do {
                let response: APIResponse<TotalPointResponse> = try await self.networkClient.get(req, retries: 0)

                await MainActor.run {
                    // ✅ status check first
                    if response.status != 200 {
                        let msg = (response.error ?? response.message ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
                        let fallback = "Server error (\(response.status))"
                        let err = NSError(
                            domain: "TotalPoint",
                            code: response.status,
                            userInfo: [NSLocalizedDescriptionKey: msg.isEmpty ? fallback : msg]
                        )
                        self.output?.didFail(err)
                        return
                    }

                    guard let data = response.data else {
                        let msg = (response.error ?? response.message ?? "No data received")
                            .trimmingCharacters(in: .whitespacesAndNewlines)
                        let err = NSError(
                            domain: "TotalPoint",
                            code: -1,
                            userInfo: [NSLocalizedDescriptionKey: msg.isEmpty ? "No data received" : msg]
                        )
                        self.output?.didFail(err)
                        return
                    }

                    self.output?.didReceivePointDetails(data)
                }
            } catch {
                await MainActor.run { self.output?.didFail(error) }
            }
        }
    }
}

//final class TotalPointInteractor: TotalPointInteractorInputProtocol {
//    weak var output: TotalPointInteractorOutputProtocol?
//    private let networkClient: NetworkClient
//    
//    init(networkClient: NetworkClient = NetworkClient()) {
//        self.networkClient = networkClient
//    }
//    
//    func getScoreDetails() {
//        Task { [weak self] in
//            guard let self else { return }
//            var req = APIRequest(path: APIConstants.totalPointURL)
//            req.method = .get
//            do {
//                let response: APIResponse<TotalPointResponse> = try await self.networkClient.get(req)
//                if let data = response.data {
//                    await MainActor.run { self.output?.didReceivePointDetails(data) }
//                } else {
//                    let error = NSError(domain: "TotalScoreInteractorError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])
//                    await MainActor.run { self.output?.didFail(error) }
//                }
//            } catch {
//                await MainActor.run { self.output?.didFail(error) }
//            }
//        }
//    }
//}

//
//
//  SubscriptionHistoryInteractor.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 21/10/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import Foundation

final class SubscriptionHistoryInteractor: SubscriptionHistoryInteractorInputProtocol {

    weak var presenter: SubscriptionHistoryInteractorOutputProtocol?
    private let networkClient: NetworkClientProtocol

    init(networkClient: NetworkClientProtocol = NetworkClient()) {
        self.networkClient = networkClient
    }

    func getSubscriptionHistory() {
        Task { [weak self] in
            guard let self else { return }

            var req = APIRequest(path: APIConstants.subscriptionHistoryURL)
            req.method = .get

            do {
                let response: APIResponse<SubscriptionHistoryResponse> = try await self.networkClient.get(req, retries: 0)

                await MainActor.run {
                    // ✅ show real server message if status != 200
                    if response.status != 200 {
                        let msg = (response.error ?? response.message ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
                        let fallback = "Server error (\(response.status))"
                        let err = NSError(
                            domain: "SubscriptionHistory",
                            code: response.status,
                            userInfo: [NSLocalizedDescriptionKey: msg.isEmpty ? fallback : msg]
                        )
                        self.presenter?.didReceivedErrorWhileFetchingSubscriptionHistory(error: err)
                        return
                    }

                    guard let data = response.data else {
                        let msg = (response.error ?? response.message ?? "Empty data").trimmingCharacters(in: .whitespacesAndNewlines)
                        let err = NSError(
                            domain: "SubscriptionHistory",
                            code: -1,
                            userInfo: [NSLocalizedDescriptionKey: msg.isEmpty ? "Empty data" : msg]
                        )
                        self.presenter?.didReceivedErrorWhileFetchingSubscriptionHistory(error: err)
                        return
                    }

                    self.presenter?.didReceivedSubscriptionHistory(history: data)
                }
            } catch {
                await MainActor.run {
                    self.presenter?.didReceivedErrorWhileFetchingSubscriptionHistory(error: error)
                }
            }
        }
    }
}

//class SubscriptionHistoryInteractor: SubscriptionHistoryInteractorInputProtocol {
//    weak var presenter: SubscriptionHistoryInteractorOutputProtocol?
//    private let networkClient: NetworkClient
//    
//    init(networkClient: NetworkClient = NetworkClient()) {
//        self.networkClient = networkClient
//    }
//    
//    func getSubscriptionHistory() {
//        Task { [weak self] in
//            guard let self else { return }
//            
//            var req = APIRequest(path: APIConstants.subscriptionHistoryURL)
//            req.method = .get
//            do {
//                let response: APIResponse<SubscriptionHistoryResponse> = try await self.networkClient.get(req)
//                await MainActor.run {
//                    guard let data = response.data else { return }
//                    self.presenter?.didReceivedSubscriptionHistory(history: data)
//                }
//            } catch {
//                await MainActor.run {
//                    Log.info(error.localizedDescription)
//                    self.presenter?.didReceivedErrorWhileFetchingSubscriptionHistory(error: error)
//                }
//            }
//        }
//    }
//}

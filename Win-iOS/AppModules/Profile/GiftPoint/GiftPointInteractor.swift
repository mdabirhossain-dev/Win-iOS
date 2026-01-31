//
//
//  GiftPointInteractor.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 25/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//



import Foundation

final class GiftPointInteractor: GiftPointInteractorProtocol {

    weak var output: GiftPointInteractorOutput?
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient = NetworkClient()) {
        self.networkClient = networkClient
    }

    func fetchUserSummary() {
        Task { [weak self] in
            guard let self else { return }

            var request = APIRequest(path: APIConstants.userSummeryURL)
            request.method = .get

            do {
                let response: APIResponse<UserSummaryResponse> = try await networkClient.get(request)
                await MainActor.run {
                    if let data = response.data {
                        self.output?.userSummaryFetched(data)
                        return
                    }
                    let msg = response.message ?? response.error ?? "প্রোফাইল তথ্য লোড করা যায়নি"
                    self.output?.userSummaryFailed(msg)
                }
            } catch {
                await MainActor.run {
                    self.output?.userSummaryFailed("নেটওয়ার্ক সমস্যা। আবার চেষ্টা করুন")
                }
            }
        }
    }

    func fetchReceiverInfo(msisdn: String) {
        Task { [weak self] in
            guard let self else { return }

            var request = APIRequest(path: APIConstants.getReceiverForTransferURL(msisdn))
            request.method = .get

            do {
                let response: APIResponse<UserInfo> = try await networkClient.get(request)
                await MainActor.run {
                    guard response.status == 200, let data = response.data else {
                        let msg = response.message ?? response.error ?? "প্রাপকের তথ্য পাওয়া যায়নি"
                        self.output?.receiverInfoFailed(msg)
                        return
                    }
                    self.output?.receiverInfoFetched(data)
                }
            } catch {
                await MainActor.run {
                    self.output?.receiverInfoFailed("নেটওয়ার্ক সমস্যা। আবার চেষ্টা করুন")
                }
            }
        }
    }

    func transferPoints(_ request: PointTransferRequest) {
        Task { [weak self] in
            guard let self else { return }

            // keep your current API style (query used for post)
            let query: [String: String] = [
                "ReceiverMsisdn": request.receiverMSISDN,
                "WalletId": String(request.walletID),
                "PointAmount": String(request.pointAmount)
            ]

            var req = APIRequest(path: APIConstants.transferPointsURL)
            req.method = .post
            req.query = query

            do {
                let response: APIResponse<Bool> = try await networkClient.post(req)
                await MainActor.run {
                    guard response.status == 200, response.data == true else {
                        let msg = response.message ?? response.error ?? "পয়েন্ট গিফট ব্যর্থ হয়েছে"
                        self.output?.pointTransferFailed(msg)
                        return
                    }
                    self.output?.pointTransferSucceeded()
                }
            } catch {
                await MainActor.run {
                    self.output?.pointTransferFailed("নেটওয়ার্ক সমস্যা। আবার চেষ্টা করুন")
                }
            }
        }
    }
}
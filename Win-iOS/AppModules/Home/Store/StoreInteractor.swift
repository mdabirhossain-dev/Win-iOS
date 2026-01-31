//
//
//  StoreInteractor.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 25/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//



import Foundation

final class StoreInteractor: StoreInteractorProtocol {

    weak var output: StoreInteractorOutput?
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient = NetworkClient()) {
        self.networkClient = networkClient
    }

    // NOTE: These raw values are WALLET IDs (not client IDs)
    private enum PaymentClient: Int {
        case gp = 1
        case robiAirtel = 2
        case banglalink = 3
        case bkash = 4
        case googlePay = 7

        enum Flow { case otp, web }

        var flow: Flow {
            switch self {
            case .gp, .banglalink: return .otp
            case .robiAirtel, .bkash, .googlePay: return .web
            }
        }

        var initiatePath: String {
            switch self {
            case .gp: return APIConstants.requestOTPFromGpURL
            case .banglalink: return APIConstants.requestOTPFromBanglalinkURL
            case .robiAirtel: return APIConstants.requestOTPFromRobiAirtelURL
            case .bkash: return APIConstants.paymentBkashURL
            case .googlePay: return APIConstants.paymentBkashURL // placeholder
            }
        }

        var completionPath: String? {
            switch self {
            case .gp: return APIConstants.paymentCompletionFromGpURL
            case .banglalink: return APIConstants.paymentCompletionFromBanglalinkURL
            case .robiAirtel, .bkash, .googlePay: return nil
            }
        }
    }

    func fetchWallets() {
        Task { [weak self] in
            guard let self else { return }

            var request = APIRequest(path: APIConstants.getWalletsURL)
            request.method = .get

            do {
                let response: APIResponse<PaymentWallets> = try await networkClient.get(request)

                await MainActor.run {
                    let wallets = response.data ?? []
                    self.output?.walletsFetched(wallets)
                }
            } catch {
                await MainActor.run {
                    self.output?.walletsFailed("পেমেন্ট ওয়ালেট লোড করা যায়নি")
                }
            }
        }
    }

    func fetchPlans(walletID: Int) {
        Task { [weak self] in
            guard let self else { return }

            var request = APIRequest(path: APIConstants.getPlansURL(walletID))
            request.method = .get

            do {
                let response: APIResponse<PurchasePlansData> = try await networkClient.get(request)

                await MainActor.run {
                    if let data = response.data {
                        self.output?.plansFetched(data)
                        return
                    }
                    self.output?.plansFailed(response.message ?? response.error ?? "প্ল্যান লোড করা যায়নি")
                }
            } catch {
                await MainActor.run {
                    self.output?.plansFailed("নেটওয়ার্ক সমস্যা। আবার চেষ্টা করুন")
                }
            }
        }
    }

    func startPurchase(walletID: Int, planID: Int) {
        guard let client = PaymentClient(rawValue: walletID) else {
            output?.plansFailed("Unsupported walletID: \(walletID)")
            return
        }

        switch client.flow {
        case .otp:
            initiateOTPFlow(client: client, walletID: walletID, planID: planID)
        case .web:
            initiateWebFlow(client: client, walletID: walletID, planID: planID)
        }
    }

    private func initiateOTPFlow(client: PaymentClient, walletID: Int, planID: Int) {
        Task { [weak self] in
            guard let self else { return }

            var request = APIRequest(path: client.initiatePath)
            request.method = .get
            request.query = [
                "walletId": "\(walletID)",
                "planId": "\(planID)"
            ]

            do {
                let response: APIResponse<String> = try await networkClient.get(request)

                await MainActor.run {
                    guard let correlator = response.data, !correlator.isEmpty else {
                        self.output?.plansFailed(response.message ?? "OTP পাওয়া যায়নি")
                        return
                    }
                    self.output?.requireOTP(clientCorrelator: correlator)
                }
            } catch {
                await MainActor.run {
                    self.output?.plansFailed("OTP নেওয়া যায়নি। আবার চেষ্টা করুন")
                }
            }
        }
    }

    func completeOTPFlow(walletID: Int, otp: String, clientCorrelator: String) {
        guard let client = PaymentClient(rawValue: walletID),
              let path = client.completionPath else {
            output?.otpPaymentResultFailed("Unsupported OTP completion")
            return
        }

        Task { [weak self] in
            guard let self else { return }

            var request = APIRequest(path: path)
            request.method = .get
            request.query = [
                "otp": otp,
                "clientCorrelator": clientCorrelator
            ]

            do {
                let response: APIResponse<Bool> = try await networkClient.get(request)

                await MainActor.run {
                    if response.data == true {
                        self.output?.otpPaymentResultSucceeded()
                    } else {
                        let msg = response.message ?? response.error ?? "দুঃখিত! পেমেন্ট ব্যর্থ হয়েছে।"
                        self.output?.otpPaymentResultFailed(msg)
                    }
                }
            } catch {
                await MainActor.run {
                    self.output?.otpPaymentResultFailed("নেটওয়ার্ক সমস্যা। আবার চেষ্টা করুন")
                }
            }
        }
    }

    private func initiateWebFlow(client: PaymentClient, walletID: Int, planID: Int) {
        Task { [weak self] in
            guard let self else { return }

            var request = APIRequest(path: client.initiatePath)
            request.method = .get
            request.query = [
                "walletId": "\(walletID)",
                "planId": "\(planID)"
            ]

            do {
                let response: APIResponse<String> = try await networkClient.get(request)

                await MainActor.run {
                    guard let urlString = response.data, !urlString.isEmpty else {
                        self.output?.plansFailed(response.message ?? "Payment URL পাওয়া যায়নি")
                        return
                    }
                    self.output?.openWeb(urlString: urlString)
                }
            } catch {
                await MainActor.run {
                    self.output?.plansFailed("পেমেন্ট শুরু করা যায়নি")
                }
            }
        }
    }
}
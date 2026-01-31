//
//
//  HomeInteractor.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 25/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//



import Foundation

final class HomeInteractor: HomeInteractorProtocol {

    weak var output: HomeInteractorOutput?
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient = NetworkClient()) {
        self.networkClient = networkClient
    }

    func fetchHomeContents() {
        Task { [weak self] in
            guard let self else { return }

            var request = APIRequest(path: APIConstants.homeContentURL)
            request.method = .get

            do {
                let response: APIResponse<HomeContents> = try await networkClient.get(request)
                await MainActor.run {
                    if let data = response.data {
                        self.output?.homeContentsFetched(data)
                    } else {
                        self.output?.homeContentsFailed(response.message ?? response.error ?? "Home content পাওয়া যায়নি")
                    }
                }
            } catch {
                await MainActor.run {
                    self.output?.homeContentsFailed("নেটওয়ার্ক সমস্যা। আবার চেষ্টা করুন")
                }
            }
        }
    }

    func fetchRedemptionLeaderboard() {
        Task { [weak self] in
            guard let self else { return }

            var request = APIRequest(path: APIConstants.redemptionLeaderboardURL)
            request.method = .get

            do {
                let response: APIResponse<RedemptionLeaderboard> = try await networkClient.get(request)
                await MainActor.run {
                    if let data = response.data {
                        self.output?.redemptionLeaderboardFetched(data)
                    } else {
                        self.output?.redemptionLeaderboardFailed(response.message ?? response.error ?? "Leaderboard পাওয়া যায়নি")
                    }
                }
            } catch {
                await MainActor.run {
                    self.output?.redemptionLeaderboardFailed("নেটওয়ার্ক সমস্যা। আবার চেষ্টা করুন")
                }
            }
        }
    }

    func fetchCampaignsWithLeaderboards() {
        Task { [weak self] in
            guard let self else { return }

            var request = APIRequest(path: APIConstants.campaignsWithLeaderboardsURL)
            request.method = .get

            do {
                let response: APIResponse<CampaignList> = try await networkClient.get(request)
                await MainActor.run {
                    if let data = response.data {
                        self.output?.campaignsWithLeaderboardsFetched(data)
                    } else {
                        self.output?.campaignsWithLeaderboardsFailed(response.message ?? response.error ?? "Campaigns পাওয়া যায়নি")
                    }
                }
            } catch {
                await MainActor.run {
                    self.output?.campaignsWithLeaderboardsFailed("নেটওয়ার্ক সমস্যা। আবার চেষ্টা করুন")
                }
            }
        }
    }
}
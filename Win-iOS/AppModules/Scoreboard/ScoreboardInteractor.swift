//
//
//  ScoreboardInteractor.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 21/10/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import Foundation

final class ScoreboardInteractor: ScoreboardInteractorProtocol {

    weak var output: ScoreboardInteractorOutput?

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient = NetworkClient()) {
        self.networkClient = networkClient
    }

    func fetchCampaignList() {
        Task { [weak self] in
            guard let self else { return }

            var request = APIRequest(path: APIConstants.campaignListURL)
            request.method = .get

            do {
                let response: APIResponse<[Campaign]> = try await networkClient.get(request)
                await MainActor.run {
                    if let data = response.data {
                        self.output?.didFetchCampaignList(data)
                    } else {
                        self.output?.didFail(response.message ?? response.error ?? "ক্যাম্পেইন ডেটা পাওয়া যায়নি")
                    }
                }
            } catch {
                await MainActor.run {
                    self.output?.didFail("ক্যাম্পেইন লোড ব্যর্থ হয়েছে")
                }
            }
        }
    }

    func fetchScoreboardCampaign(campaignID: Int) {
        Task { [weak self] in
            guard let self else { return }

            var request = APIRequest(path: APIConstants.leaderboardCampaignURL(campaignID))
            request.method = .get

            do {
                let response: APIResponse<ScoreboardCampaign> = try await networkClient.get(request)
                await MainActor.run {
                    if let data = response.data {
                        self.output?.didFetchScoreboardCampaign(data)
                    } else {
                        self.output?.didFail(response.message ?? response.error ?? "স্কোরবোর্ড ডেটা পাওয়া যায়নি")
                    }
                }
            } catch {
                await MainActor.run {
                    self.output?.didFail("স্কোরবোর্ড লোড ব্যর্থ হয়েছে")
                }
            }
        }
    }
}

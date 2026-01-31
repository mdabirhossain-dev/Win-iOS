//
//
//  UpdateProfileInteractor.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 12/11/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import Foundation

final class UpdateProfileInteractor: UpdateProfileInteractorInputProtocol {

    weak var output: UpdateProfileInteractorOutputProtocol?
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient = NetworkClient()) {
        self.networkClient = networkClient
    }

    func fetchUserAvatar() {
        Task { [weak self] in
            guard let self else { return }

            var req = APIRequest(path: APIConstants.userAvatarURL)
            req.method = .get

            do {
                let response: APIResponse<UserAvatar> = try await networkClient.get(req)
                await MainActor.run {
                    if let data = response.data {
                        self.output?.didFetchUserAvatar(data)
                    } else {
                        self.output?.didFail(
                            NSError(domain: "UpdateProfileInteractor", code: -1),
                            serverMessage: response.message ?? response.error
                        )
                    }
                }
            } catch {
                await MainActor.run {
                    self.output?.didFail(error, serverMessage: nil)
                }
            }
        }
    }

    func fetchAvatarList() {
        Task { [weak self] in
            guard let self else { return }

            var req = APIRequest(path: APIConstants.userAvatarListURL)
            req.method = .get

            do {
                let response: APIResponse<UserAvatarList> = try await networkClient.get(req)
                await MainActor.run {
                    if let data = response.data {
                        self.output?.didFetchAvatarList(data)
                    } else {
                        self.output?.didFail(
                            NSError(domain: "UpdateProfileInteractor", code: -2),
                            serverMessage: response.message ?? response.error
                        )
                    }
                }
            } catch {
                await MainActor.run {
                    self.output?.didFail(error, serverMessage: nil)
                }
            }
        }
    }

    func updateProfile(request: UpdateProfileRequest) {
        Task { [weak self] in
            guard let self else { return }

            var req = APIRequest(path: APIConstants.updateProfileURL)
            req.method = .post
            req.body = request

            do {
                let response: APIResponse<EmptyData> = try await networkClient.post(req)
                await MainActor.run {
                    if response.status == 200 {
                        self.output?.didUpdateProfileSuccess(serverMessage: response.message)
                    } else {
                        self.output?.didFail(
                            NSError(domain: "UpdateProfileInteractor", code: response.status),
                            serverMessage: response.message ?? response.error
                        )
                    }
                }
            } catch {
                await MainActor.run {
                    self.output?.didFail(error, serverMessage: nil)
                }
            }
        }
    }
}

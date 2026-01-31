//
//
//  HelpAndSupportInteractor.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 12/11/25.
//  Contact me if anything is needed:
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import Foundation

final class HelpAndSupportInteractor: HelpAndSupportInteractorInputProtocol {

    weak var output: HelpAndSupportInteractorOutputProtocol?
    private let networkClient: NetworkClientProtocol

    init(networkClient: NetworkClientProtocol = NetworkClient()) {
        self.networkClient = networkClient
    }

    func postHelpAndSupport(request: HelpAndSupportRequest) {
        Task { [weak self] in
            guard let self else { return }

            var apiRequest = APIRequest(path: APIConstants.helpAndSupportURL)
            apiRequest.method = .post
            apiRequest.body = request

            do {
                let response: APIResponse<EmptyData> = try await networkClient.post(apiRequest, retries: 0)

                await MainActor.run {
                    if response.status == 200, response.message?.lowercased() == "success" {
                        self.output?.postHelpAndSupportSucceeded(responseMessage: response.message ?? "")
                        return
                    }

                    // ✅ show real server error/message in toast
                    let serverMsg = (response.error ?? response.message ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
                    if !serverMsg.isEmpty {
                        self.output?.postHelpAndSupportFailedWithServerMessage(serverMsg)
                        return
                    }

                    let fallback = "Unknown server error"
                    let err = NSError(
                        domain: "HelpAndSupport",
                        code: response.status,
                        userInfo: [NSLocalizedDescriptionKey: fallback]
                    )
                    self.output?.postHelpAndSupportFailed(error: err)
                }
            } catch {
                await MainActor.run {
                    self.output?.postHelpAndSupportFailed(error: error)
                }
            }
        }
    }
}

//final class HelpAndSupportInteractor: HelpAndSupportInteractorInputProtocol {
//    
//    weak var output: HelpAndSupportInteractorOutputProtocol?
//    private let networkClient: NetworkClient
//    
//    init(networkClient: NetworkClient = NetworkClient()) {
//        self.networkClient = networkClient
//    }
//    
//    func postHelpAndSupport(request: HelpAndSupportRequest) {
//        Task { [weak self] in
//            guard let self else { return }
//            
//            var apiRequest = APIRequest(path: APIConstants.helpAndSupportURL)
//            apiRequest.method = .post
//            apiRequest.body = request
//            
//            do {
//                let response: APIResponse<EmptyData> = try await networkClient.post(apiRequest)
//                
//                await MainActor.run {
//                    if response.status == 200,
//                       response.message?.lowercased() == "success" {
//                        self.output?.postHelpAndSupportSucceeded(responseMessage: response.message ?? "")
//                    } else if let serverErrorMessage = response.error, !serverErrorMessage.isEmpty {
//                        self.output?.postHelpAndSupportFailedWithServerMessage(serverErrorMessage)
//                    } else {
//                        let msg = ((response.message?.isEmpty) != nil) ? response.message : "Unknown server error"
//                        let error = NSError(
//                            domain: "HelpAndSupport",
//                            code: response.status,
//                            userInfo: [NSLocalizedDescriptionKey: msg]
//                        )
//                        self.output?.postHelpAndSupportFailed(error: error)
//                    }
//                }
//            } catch {
//                await MainActor.run {
//                    self.output?.postHelpAndSupportFailed(error: error)
//                }
//            }
//        }
//    }
//}


//
//
//  NetworkClientFake.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 13/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//

import Foundation

// MARK: - FOR UnitTest
final class NetworkClientFake: NetworkClientProtocol {
    var getHandler: ((APIRequest, Int) async throws -> Any)?
    var postHandler: ((APIRequest, Int) async throws -> Any)?
    var putHandler: ((APIRequest, Int) async throws -> Any)?
    var deleteHandler: ((APIRequest, Int) async throws -> Any)?
    var patchHandler: ((APIRequest, Int) async throws -> Any)?

    func get<T: Decodable>(_ request: APIRequest, retries: Int) async throws -> T {
        guard let getHandler else { fatalError("getHandler not set") }
        let value = try await getHandler(request, retries)
        guard let casted = value as? T else { fatalError("Type mismatch in getHandler. Expected \(T.self)") }
        return casted
    }

    func post<T: Decodable>(_ request: APIRequest, retries: Int) async throws -> T {
        guard let postHandler else { fatalError("postHandler not set") }
        let value = try await postHandler(request, retries)
        guard let casted = value as? T else { fatalError("Type mismatch in postHandler. Expected \(T.self)") }
        return casted
    }

    func put<T: Decodable>(_ request: APIRequest, retries: Int) async throws -> T {
        guard let putHandler else { fatalError("putHandler not set") }
        let value = try await putHandler(request, retries)
        guard let casted = value as? T else { fatalError("Type mismatch in putHandler. Expected \(T.self)") }
        return casted
    }

    func delete<T: Decodable>(_ request: APIRequest, retries: Int) async throws -> T {
        guard let deleteHandler else { fatalError("deleteHandler not set") }
        let value = try await deleteHandler(request, retries)
        guard let casted = value as? T else { fatalError("Type mismatch in deleteHandler. Expected \(T.self)") }
        return casted
    }

    func patch<T: Decodable>(_ request: APIRequest, retries: Int) async throws -> T {
        guard let patchHandler else { fatalError("patchHandler not set") }
        let value = try await patchHandler(request, retries)
        guard let casted = value as? T else { fatalError("Type mismatch in patchHandler. Expected \(T.self)") }
        return casted
    }
}

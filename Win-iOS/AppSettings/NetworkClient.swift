//
//
//  NetworkClient.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 16/10/25.
//  Contact me if anything is needed:
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import Foundation

protocol NetworkClientProtocol: AnyObject {
    func get<T: Decodable>(_ request: APIRequest, retries: Int) async throws -> T
    func post<T: Decodable>(_ request: APIRequest, retries: Int) async throws -> T
    func put<T: Decodable>(_ request: APIRequest, retries: Int) async throws -> T
    func delete<T: Decodable>(_ request: APIRequest, retries: Int) async throws -> T
    func patch<T: Decodable>(_ request: APIRequest, retries: Int) async throws -> T
}

extension NetworkClient: NetworkClientProtocol { }


// MARK: - Network types
public enum HTTPMethod: String {
    case get = "GET", post = "POST", put = "PUT", delete = "DELETE", patch = "PATCH"
}

public enum APIError: Error {
    case badURL, transport(Error), invalidResponse, server(statusCode: Int), emptyData, decoding(Error), encoding(Error)
}

// MARK: - Base Response
struct APIResponse<T: Decodable>: Decodable {
    let status: Int
    let message: String?
    let data: T?
    let error: String?
}

// MARK: - Empty Response
struct EmptyData: Decodable {}

// MARK: - A small request descriptor
public struct APIRequest {
    public let path: String
    public var method: HTTPMethod = .get
    public var query: [String: String]? = nil
    public var headers: [String: String]? = nil
    public var body: Encodable? = nil
    public var cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy
    public var timeout: TimeInterval = 60
    
    public init(path: String) { self.path = path }
}

// MARK: - Network Client
public final class NetworkClient {
    private let baseURL: URL?
    private let session: URLSession

    // ✅ HARD-CODED HEADERS (always included)
    private let coreHeaders: [String: String] = [
        "sourcePlatform": "android",
//        "client": "0",
        "Accept": "application/json"
    ]

    private let cache = NSCache<NSString, NSData>() // simple GET cache
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    // NOTE: keeping your original behavior (token loaded once at init)
    // If you want latest token each request, tell me and I'll fix it cleanly.
    private let token: String? = KeychainManager.shared.token

    public init(
        baseURL: URL? = nil,
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder(),
        encoder: JSONEncoder = JSONEncoder()
    ) {
        self.baseURL = baseURL
        self.session = session
        self.decoder = decoder
        self.encoder = encoder
    }

    // MARK: - Public Convenience Methods (async)
    public func get<T: Decodable>(_ request: APIRequest, retries: Int = 0) async throws -> T {
        var r = request; r.method = .get
        return try await requestDecodable(r, retries: retries)
    }
    public func post<T: Decodable>(_ request: APIRequest, retries: Int = 0) async throws -> T {
        var r = request; r.method = .post
        return try await requestDecodable(r, retries: retries)
    }
    public func put<T: Decodable>(_ request: APIRequest, retries: Int = 0) async throws -> T {
        var r = request; r.method = .put
        return try await requestDecodable(r, retries: retries)
    }
    public func delete<T: Decodable>(_ request: APIRequest, retries: Int = 0) async throws -> T {
        var r = request; r.method = .delete
        return try await requestDecodable(r, retries: retries)
    }
    public func patch<T: Decodable>(_ request: APIRequest, retries: Int = 0) async throws -> T {
        var r = request; r.method = .patch
        return try await requestDecodable(r, retries: retries)
    }

    // MARK: - Public Completion-based API
    public func request<T: Decodable>(
        _ request: APIRequest,
        retries: Int = 0,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        Task {
            do {
                let result: T = try await self.requestDecodable(request, retries: retries)
                completion(.success(result))
            } catch let err as APIError {
                completion(.failure(err))
            } catch {
                completion(.failure(.transport(error)))
            }
        }
    }

    // MARK: - Core async request
    private func requestDecodable<T: Decodable>(_ apiReq: APIRequest, retries: Int) async throws -> T {
        let urlRequest = try buildURLRequest(from: apiReq)

        // Simple GET cache
        if apiReq.method == .get, let cached = cache.object(forKey: cacheKey(for: urlRequest)) {
            do {
                let decoded = try decoder.decode(T.self, from: cached as Data)
                return decoded
            } catch {
                // fallthrough to network fetch if decode fails
            }
        }

        var currentAttempt = 0
        var lastError: Error?

        while currentAttempt <= retries {
            do {
                let (data, response) = try await session.data(for: urlRequest)
                guard let http = response as? HTTPURLResponse else { throw APIError.invalidResponse }
                guard (200...299).contains(http.statusCode) else { throw APIError.server(statusCode: http.statusCode) }
                guard !data.isEmpty else { throw APIError.emptyData }

                // cache GET responses
                if apiReq.method == .get {
                    cache.setObject(data as NSData, forKey: cacheKey(for: urlRequest))
                }

                do {
                    let decoded = try decoder.decode(T.self, from: data)
                    return decoded
                } catch {
                    throw APIError.decoding(error)
                }
            } catch {
                lastError = error
                currentAttempt += 1
                if currentAttempt <= retries {
                    // simple exponential backoff
                    let backoff = UInt64(pow(2.0, Double(currentAttempt))) * 100_000_000 // in ns
                    try? await Task.sleep(nanoseconds: backoff)
                }
            }
        }

        if let apiErr = lastError as? APIError { throw apiErr }
        throw APIError.transport(lastError ?? URLError(.unknown))
    }

    // MARK: - Helpers
    private func buildURLRequest(from apiReq: APIRequest) throws -> URLRequest {
        // Build URL
        let full: URL
        if let base = baseURL {
            guard let url = URL(string: apiReq.path, relativeTo: base)?.absoluteURL else { throw APIError.badURL }
            full = urlWithQuery(url: url, query: apiReq.query)
        } else {
            guard let url = URL(string: apiReq.path) else { throw APIError.badURL }
            full = urlWithQuery(url: url, query: apiReq.query)
        }

        var request = URLRequest(url: full, cachePolicy: apiReq.cachePolicy, timeoutInterval: apiReq.timeout)
        request.httpMethod = apiReq.method.rawValue

        // ✅ Merge headers: coreHeaders ALWAYS included, apiReq.headers ADDED/OVERRIDES
        var combined = coreHeaders
        apiReq.headers?.forEach { combined[$0.key] = $0.value }

        if let token = token, combined["Authorization"] == nil {
            combined["Authorization"] = "Bearer \(token)"
        }

        combined.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }

        // Body
        if let body = apiReq.body {
            do {
                request.httpBody = try encodeBody(body)
                if request.value(forHTTPHeaderField: "Content-Type") == nil {
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                }
            } catch {
                throw APIError.encoding(error)
            }
        }

        return request
    }

    private func urlWithQuery(url: URL, query: [String: String]?) -> URL {
        guard let query = query, !query.isEmpty else { return url }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        var items = components?.queryItems ?? []
        items.append(contentsOf: query.map { URLQueryItem(name: $0.key, value: $0.value) })
        components?.queryItems = items
        return components?.url ?? url
    }

    private func encodeBody(_ body: Encodable) throws -> Data {
        if let d = body as? Data { return d }
        return try encoder.encode(AnyEncodable(body))
    }

    private func cacheKey(for request: URLRequest) -> NSString {
        let key = "\(request.httpMethod ?? "GET"):\(request.url?.absoluteString ?? "")"
        return NSString(string: key)
    }
}

// MARK: - AnyEncodable helper
fileprivate struct AnyEncodable: Encodable {
    private let _encode: (Encoder) throws -> Void
    init(_ encodable: Encodable) {
        self._encode = { encoder in try encodable.encode(to: encoder) }
    }
    func encode(to encoder: Encoder) throws { try _encode(encoder) }
}


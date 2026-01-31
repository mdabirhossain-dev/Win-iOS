//
//
//  KeychainManager.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 20/10/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import Foundation
import Security

public enum KeychainKey: String {
    case msisdn
    case password
    case token
}

public struct AuthBundle {
    public let msisdn: String
    public let password: String
    public let token: String
}

// MARK: - Keychain Manager

public final class KeychainManager {
    public static let shared = KeychainManager()
    
    private let service: String
    private let accessible: CFString = kSecAttrAccessibleWhenUnlockedThisDeviceOnly
    
    private init(service: String? = Bundle.main.bundleIdentifier) {
        self.service = service ?? "AppKeychain"
    }
}

// MARK: - Public Interface (no throws)
public extension KeychainManager {
    var msisdn: String { readString(for: .msisdn) ?? "" }
    var password: String { readString(for: .password) ?? "" }
    var token: String { readString(for: .token) ?? "" }
}

public extension KeychainManager {
    
    // MARK: - Save / Update
    func saveAuth(msisdn: String? = nil, password: String? = nil, token: String? = nil) {
        if let msisdn { saveString(msisdn, for: .msisdn) }
        if let password { saveString(password, for: .password) }
        if let token { saveString(token, for: .token) }
    }
    
    func updateAuth(msisdn: String? = nil, password: String? = nil, token: String? = nil) {
        // same as saveAuth — upsert behavior
        saveAuth(msisdn: msisdn, password: password, token: token)
    }
    
    // MARK: - Read
    func readAuth() -> AuthBundle? {
        guard
            let msisdn = readString(for: .msisdn),
            let password = readString(for: .password),
            let token = readString(for: .token)
        else { return nil }
        
        return AuthBundle(msisdn: msisdn, password: password, token: token)
    }
    
    // MARK: - Delete
    
    func deleteAuth(msisdn: Bool = false, password: Bool = false, token: Bool = false) {
        if !msisdn && !password && !token {
            deleteAll()
            return
        }
        if msisdn { delete(.msisdn) }
        if password { delete(.password) }
        if token { delete(.token) }
    }
}

// MARK: - Private Helpers

private extension KeychainManager {
    
    func baseQuery(for key: KeychainKey) -> [CFString: Any] {
        [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: key.rawValue,
            kSecAttrAccessible: accessible
        ]
    }
    
    func saveString(_ value: String, for key: KeychainKey) {
        let data = Data(value.utf8)
        var query = baseQuery(for: key)
        query[kSecValueData] = data
        
        let status = SecItemAdd(query as CFDictionary, nil)
        if status == errSecDuplicateItem {
            let updateQuery = baseQuery(for: key)
            let attrs = [kSecValueData: data]
            SecItemUpdate(updateQuery as CFDictionary, attrs as CFDictionary)
        }
    }
    
    func readString(for key: KeychainKey) -> String? {
        var query = baseQuery(for: key)
        query[kSecReturnData] = kCFBooleanTrue
        query[kSecMatchLimit] = kSecMatchLimitOne
        
        var out: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &out)
        guard status == errSecSuccess, let data = out as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    func delete(_ key: KeychainKey) {
        SecItemDelete(baseQuery(for: key) as CFDictionary)
    }
    
    func deleteAll() {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service
        ]
        SecItemDelete(query as CFDictionary)
    }
}

enum FirstLaunchGuard {
    private static let flagKey = Bundle.main.bundleIdentifier ?? "com.cloud7bd.Win-iOS"

    /// Returns true exactly once after a clean install.
    @discardableResult
    static func isFirstLaunch() -> Bool {
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: flagKey) == false {
            defaults.set(true, forKey: flagKey)
            return true
        }
        return false
    }
}

public extension KeychainManager {
    func debugDumpAuth() {
        Log.info("msisdn: \(readString(for: .msisdn) ?? "nil")")
        Log.info("password: \(readString(for: .password) ?? "nil")")
        Log.info("token: \(readString(for: .token) ?? "nil")")
    }
}

public extension KeychainManager {
    /// Call this once at app start. If the app was freshly installed,
    /// we wipe all keychain items under this service.
    func handleFirstLaunchResetIfNeeded() {
        if FirstLaunchGuard.isFirstLaunch() {
            // wipe everything for this service
            deleteAll()
        }
    }
}

//// MARK: - Public keys you’ll use around the app
//public enum KeychainKey: String {
//    case msisdn
//    case password
//    case token
//}
//
//// MARK: - Errors
//public enum KCError: Error, LocalizedError {
//    case notFound
//    case unexpectedData
//    case unexpectedStatus(OSStatus)
//    
//    public var errorDescription: String? {
//        switch self {
//        case .notFound: return "Item not found in Keychain."
//        case .unexpectedData: return "Unexpected data format."
//        case .unexpectedStatus(let s): return "Keychain error: \(s)"
//        }
//    }
//}
//
//// MARK: - Manager
//public final class KeychainManager {
//    public static let shared = KeychainManager()
//    
//    /// Customize these if you want shared access groups or different accessibility.
//    private let service: String
//    private let accessible: CFString
//    private let synchronizable: Bool
//    private let accessGroup: String?
//    
//    /// Defaults:
//    /// - Service: bundle identifier (falls back to app name)
//    /// - Accessibility: whenUnlockedThisDeviceOnly (strong, avoids iCloud restore)
//    /// - Synchronizable: false (not in iCloud Keychain)
//    private init(service: String? = Bundle.main.bundleIdentifier,
//                 accessible: CFString = kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
//                 synchronizable: Bool = false,
//                 accessGroup: String? = nil) {
//        self.service = service ?? (Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "AppKeychain")
//        self.accessible = accessible
//        self.synchronizable = synchronizable
//        self.accessGroup = accessGroup
//    }
//}
//
//// MARK: - Low-level helpers
//private extension KeychainManager {
//    func baseQuery(for key: KeychainKey) -> [CFString: Any] {
//        var q: [CFString: Any] = [
//            kSecClass: kSecClassGenericPassword,
//            kSecAttrService: service,
//            kSecAttrAccount: key.rawValue,
//            kSecAttrAccessible: accessible
//        ]
//        if synchronizable { q[kSecAttrSynchronizable] = kSecAttrSynchronizableAny }
//        if let accessGroup { q[kSecAttrAccessGroup] = accessGroup }
//        return q
//    }
//    
//    func addOrUpdate(_ data: Data, for key: KeychainKey) throws {
//        var addQuery = baseQuery(for: key)
//        addQuery[kSecValueData] = data
//        if synchronizable { addQuery[kSecAttrSynchronizable] = kCFBooleanTrue }
//        
//        let status = SecItemAdd(addQuery as CFDictionary, nil)
//        switch status {
//        case errSecSuccess:
//            return
//        case errSecDuplicateItem:
//            // Update existing
//            let updateQuery = baseQuery(for: key)
//            let attrsToUpdate: [CFString: Any] = [kSecValueData: data]
//            let updateStatus = SecItemUpdate(updateQuery as CFDictionary, attrsToUpdate as CFDictionary)
//            guard updateStatus == errSecSuccess else { throw KCError.unexpectedStatus(updateStatus) }
//        default:
//            throw KCError.unexpectedStatus(status)
//        }
//    }
//    
//    func readData(for key: KeychainKey) throws -> Data {
//        var query = baseQuery(for: key)
//        query[kSecReturnData] = kCFBooleanTrue
//        query[kSecMatchLimit] = kSecMatchLimitOne
//        
//        var out: CFTypeRef?
//        let status = SecItemCopyMatching(query as CFDictionary, &out)
//        switch status {
//        case errSecSuccess:
//            guard let data = out as? Data else { throw KCError.unexpectedData }
//            return data
//        case errSecItemNotFound:
//            throw KCError.notFound
//        default:
//            throw KCError.unexpectedStatus(status)
//        }
//    }
//    
//    func deleteItem(for key: KeychainKey) throws {
//        let status = SecItemDelete(baseQuery(for: key) as CFDictionary)
//        switch status {
//        case errSecSuccess, errSecItemNotFound:
//            return // both are fine for our flows
//        default:
//            throw KCError.unexpectedStatus(status)
//        }
//    }
//    
//    func deleteAll() throws {
//        var q: [CFString: Any] = [
//            kSecClass: kSecClassGenericPassword,
//            kSecAttrService: service
//        ]
//        if synchronizable { q[kSecAttrSynchronizable] = kSecAttrSynchronizableAny }
//        if let accessGroup { q[kSecAttrAccessGroup] = accessGroup }
//        
//        let status = SecItemDelete(q as CFDictionary)
//        switch status {
//        case errSecSuccess, errSecItemNotFound:
//            return
//        default:
//            throw KCError.unexpectedStatus(status)
//        }
//    }
//}
//
//// MARK: - Public CRUD for strings
//public extension KeychainManager {
//    @discardableResult
//    func saveString(_ value: String, for key: KeychainKey) throws -> Void {
//        try addOrUpdate(Data(value.utf8), for: key)
//    }
//    
//    func readString(for key: KeychainKey) throws -> String {
//        let data = try readData(for: key)
//        guard let string = String(data: data, encoding: .utf8) else { throw KCError.unexpectedData }
//        return string
//    }
//    
//    @discardableResult
//    func updateString(_ value: String, for key: KeychainKey) throws -> Void {
//        try addOrUpdate(Data(value.utf8), for: key)
//    }
//    
//    @discardableResult
//    func delete(_ key: KeychainKey) throws -> Void {
//        try deleteItem(for: key)
//    }
//    
//    /// Wipes all items under this service (use on logout)
//    @discardableResult
//    func resetAll() throws -> Void {
//        try deleteAll()
//    }
//}
//
//// MARK: - Convenience: auth bundle (userId, password, token)
//public struct AuthBundle {
//    public let msisdn: String
//    public let password: String
//    public let token: String
//}
//
//public extension KeychainManager {
//    /// Save all three. Any nil is ignored (good for partial updates).
//    func saveAuth(msisdn: String? = nil, password: String? = nil, token: String? = nil) throws {
//        if let msisdn { try saveString(msisdn, for: .msisdn) }
//        if let password { try saveString(password, for: .password) }
//        if let token { try saveString(token, for: .token) }
//    }
//    
//    /// Update just one or more fields. Same effect as saveAuth, reads better semantically.
//    func updateAuth(msisdn: String? = nil, password: String? = nil, token: String? = nil) throws {
//        try saveAuth(msisdn: msisdn, password: password, token: token)
//    }
//    
//    /// Read all three (throws .notFound if any is missing)
//    func readAuth() throws -> AuthBundle {
//        let msisdn = try readString(for: .msisdn)
//        let password = try readString(for: .password)
//        let token = try readString(for: .token)
//        return AuthBundle(msisdn: msisdn, password: password, token: token)
//    }
//    
//    /// Delete one or more fields. If none provided, deletes all.
//    func deleteAuth(msisdn: Bool = false, password: Bool = false, token: Bool = false) throws {
//        if !msisdn && !password && !token {
//            try resetAll()
//            return
//        }
//        if msisdn { try delete(.msisdn) }
//        if password { try delete(.password) }
//        if token { try delete(.token) }
//    }
//}

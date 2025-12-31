//
//  KeychainTokenStore.swift
//  Notes
//
//  Created by Erman Maris on 12/31/25.
//

import Foundation
import Security

public enum KeychainTokenKey: String, Sendable {
    case accessToken
    case refreshToken
}

public enum KeychainError: Error, LocalizedError, Sendable, Equatable {
    case unexpectedStatus(OSStatus)
    case invalidData

    public var errorDescription: String? {
        switch self {
        case .unexpectedStatus(let status):
            return "Keychain error (OSStatus=\(status))."
        case .invalidData:
            return "Keychain returned invalid data."
        }
    }
}

/// Minimal Keychain wrapper for storing tokens.
/// - Stores tokens as `kSecClassGenericPassword` with `service` + `account`.
/// - Uses `.afterFirstUnlockThisDeviceOnly` (recommended for auth tokens on iOS).
public final class KeychainTokenStore: Sendable {
    private let service: String

    public init(service: String = Bundle.main.bundleIdentifier ?? "com.example.app") {
        self.service = service
    }

    public func saveToken(_ token: String, for key: KeychainTokenKey) throws {
        let data = Data(token.utf8)

        var query = baseQuery(for: key)
        query[kSecValueData as String] = data
        query[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly

        let status = SecItemAdd(query as CFDictionary, nil)
        if status == errSecSuccess { return }

        if status == errSecDuplicateItem {
            let attributesToUpdate: [String: Any] = [
                kSecValueData as String: data
            ]
            let updateStatus = SecItemUpdate(baseQuery(for: key) as CFDictionary,
                                             attributesToUpdate as CFDictionary)
            guard updateStatus == errSecSuccess else { throw KeychainError.unexpectedStatus(updateStatus) }
            return
        }

        throw KeychainError.unexpectedStatus(status)
    }

    public func readToken(for key: KeychainTokenKey) throws -> String? {
        var query = baseQuery(for: key)
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnData as String] = true

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        if status == errSecItemNotFound { return nil }
        guard status == errSecSuccess else { throw KeychainError.unexpectedStatus(status) }

        guard let data = item as? Data,
              let token = String(data: data, encoding: .utf8)
        else { throw KeychainError.invalidData }

        return token
    }

    public func deleteToken(for key: KeychainTokenKey) throws {
        let status = SecItemDelete(baseQuery(for: key) as CFDictionary)
        if status == errSecSuccess || status == errSecItemNotFound { return }
        throw KeychainError.unexpectedStatus(status)
    }

    public func clearAllTokens() throws {
        for key in [KeychainTokenKey.accessToken, .refreshToken] {
            try deleteToken(for: key)
        }
    }

    // MARK: - Helpers

    private func baseQuery(for key: KeychainTokenKey) -> [String: Any] {
        [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key.rawValue
        ]
    }
}

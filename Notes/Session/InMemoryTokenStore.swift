//
//  InMemoryTokenStore.swift
//  Notes
//
//  Created by Erman Maris on 12/30/25.
//


import Foundation

protocol TokenStoring {
    func saveToken(_ token: String)
    func readToken() -> String?
    func clearToken()
}

// For production: implement Keychain storage.
// NOTE: Don’t store secrets in UserDefaults/AppStorage.
final class InMemoryTokenStore: TokenStoring {
    private var token: String?
    func saveToken(_ token: String) { self.token = token }
    func readToken() -> String? { token }
    func clearToken() { token = nil }
}

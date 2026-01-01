//
//  SessionStore.swift
//  Notes
//
//  Created by Erman Maris on 12/30/25.
//

import Foundation

struct User: Equatable {
    let id: String
    let email: String
}

enum AuthState: Equatable {
    case loading
    case signedOut(Bool?)
    case signedIn
}

@MainActor
final class SessionStore: ObservableObject {
    @Published private(set) var state: AuthState = .loading
    let keyChain = KeychainTokenStore()
    
    private let tokenStore: TokenStoring
    private let authService: AuthServicing
    
    init(tokenStore: TokenStoring = InMemoryTokenStore(),
         authService: AuthServicing = AuthService()) {
        self.tokenStore = tokenStore
        self.authService = authService
    }
    
    // MARK: - Session fucntions
    func restoreSession() async {
        
        do {
            // Check if accessToken exists in keychain.
            // If exists, probably expired, and make refresh token call to update them.
            guard let token = try read(token: .accessToken) else {
                Logger.shared.debug("restoreSession() - accessToken does not exist")
                state = .signedOut(nil)
                return
            }
        } catch {
            Logger.shared.debug("restoreSession() - token: \(error)")
        }

        do {
            if let refreshToken = try read(token: .refreshToken) {
                try await refresh(token: refreshToken)
            }
        } catch {
            Logger.shared.debug("restoreSession() - Keychain refreshToken read failed: \(error)")
        }
    }
    
    func signIn(email: String, password: String) async throws {
        let result = try await authService.signIn(email: email, password: password)
        if let accessToken = result?.accessToken, let refreshToken = result?.refreshToken {
            save(accessToken: accessToken, refreshToken: refreshToken)
            state = .signedIn
        }
    }
    
    func register(email: String, password: String) async throws {
        let isRegisterSuccessful = try await authService.register(email: email, password: password)
        // Once register successful, present signin screen again so that they can sign-in.
        state = .signedOut(isRegisterSuccessful)
    }
    
    func refresh(token: String) async throws {
        if let loginModel = try await authService.refresh(token: token) {
            if let accessToken = loginModel.accessToken, let refreshToken = loginModel.refreshToken {
                save(accessToken: accessToken, refreshToken: refreshToken)
                state = .signedIn
            }
        }
    }

    func signOut() {
        tokenStore.clearToken()
        state = .signedOut(nil)
    }
    
    // MARK: - Keychain functions
    func save(accessToken: String, refreshToken: String) {
        do {
            try keyChain.saveToken(accessToken, for: .accessToken)
            try keyChain.saveToken(refreshToken, for: .refreshToken)
        } catch {
            print("Keychain save failed:", error)
        }
    }
    
    func read(token: KeychainTokenKey) throws -> String? {
        do {
            let access = try keyChain.readToken(for: token)
            Logger.shared.debug("read() - access: \(String(describing: access))")
            return access
        } catch {
            print("Keychain read failed:", error)
        }
        return nil
    }
    
    func clear(token: KeychainTokenKey) {
        do {
            try keyChain.deleteToken(for: token)
            Logger.shared.debug("clear() - access: \(String(describing: access))")
        } catch {
            Logger.shared.debug("clear() - Keychain read failed: \(error)")
        }
    }
}

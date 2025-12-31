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
    
    func restoreSession() async {
        guard let token = tokenStore.readToken() else {
            state = .signedOut(nil)
            return
        }
        
        print("#### the token: \(token)")
    }
    
    func signIn(email: String, password: String) async throws {
        let result = try await authService.signIn(email: email, password: password)
//        tokenStore.saveToken(result.accessToken)
        if result {
            state = .signedIn
        }
//        state = .signedIn(result.user)
    }
    
    func register(email: String, password: String) async throws {
        let isRegisterSuccessful = try await authService.register(email: email, password: password)
        print("#### isRegisterSuccessful: \(isRegisterSuccessful)")
        // Once register successful, present signin screen again so that they can sign-in.
        state = .signedOut(isRegisterSuccessful)
//        tokenStore.saveToken(result.accessToken)
//        state = .signedIn(result.user, /*result*/)
    }

    func signOut() {
        tokenStore.clearToken()
        state = .signedOut(nil)
    }
    
    func save(accessToken: String, refreshToken: String) {
        do {
            try keyChain.saveToken(accessToken, for: .accessToken)
            try keyChain.saveToken(refreshToken, for: .refreshToken)
        } catch {
            print("Keychain save failed:", error)
        }
    }
    
    func read(token: KeychainTokenKey) {
        do {
            let access = try keyChain.readToken(for: token)
            print("#### the token: \(access)")
        } catch {
            print("Keychain read failed:", error)
        }
    }
}

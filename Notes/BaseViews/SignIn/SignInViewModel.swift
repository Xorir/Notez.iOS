//
//  SignInViewModel.swift
//  Notes
//
//  Created by Erman Maris on 12/30/25.
//

import SwiftUI

struct AlertItem: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let message: String
}

@MainActor
final class SignInViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedSignInType: SignInType = .register
    @Published var alert: AlertItem?

    var canSubmit: Bool {
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        password.count >= 6 &&
        email.contains("@")
    }

    func submitSignIn(using session: SessionStore) async {
        guard canSubmit, !isLoading else { return }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            try await session.signIn(email: email, password: password)
        } catch {
            errorMessage = "Sign in failed. Please try again."
        }
    }
    
    func submitRegister(using session: SessionStore) async {
        guard canSubmit, !isLoading else { return }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            try await session.register(email: email, password: password)
        } catch {
            errorMessage = "Registration failed. Please try again."
        }
    }
    
    func presentAlertForRegistration(status: Bool) {
        let title = status ? "Success" : "Failure"
        let message = status ? "Registration completed, sign-in using credentials" : "Registration failed, try again later."
        
        self.alert = AlertItem(title: title, message: message)
    }
}

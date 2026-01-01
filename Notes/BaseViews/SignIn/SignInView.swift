//
//  SignInView.swift
//  Notes
//
//  Created by Erman Maris on 12/30/25.
//

import Foundation
import SwiftUI


enum SignInType: String, CaseIterable, Identifiable {
    case register, signIn
    var id: Self { self }
}

struct SignInView: View {
    @EnvironmentObject private var session: SessionStore
    @StateObject private var vm = SignInViewModel()

    var body: some View {
        VStack(spacing: 12) {
            Text("The Notez")
                .font(.largeTitle)
                .padding()
            
            TextField("Email", text: $vm.email)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .textContentType(.username)
                .textFieldStyle(.roundedBorder)

            SecureField("Password", text: $vm.password)
                .textContentType(.password)
                .textFieldStyle(.roundedBorder)
                .submitLabel(.done)
                .onSubmit {
                    switch vm.selectedSignInType {
                    case .register:
                        Task {
                            await vm.submitRegister(using: session)
                        }
                    case .signIn:
                        Task {
                            await vm.submitSignIn(using: session)
                        }
                    }
                }

            if let msg = vm.errorMessage {
                Text(msg).font(.footnote).foregroundStyle(.red)
            }
            
            HStack {
                Button {
                    Logger.shared.debug("Signin button tapped")
                    Task {
                        await vm.submitSignIn(using: session)
                    }
                } label: {
                    Text("Sign-In")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .foregroundStyle(.white)
                .background(Color.purple)
                .cornerRadius(10)
            }
            
            HStack {
                Spacer()
                Button {
                    Logger.shared.debug("Sign up button tapped")
                } label: {
                    Text("Sign Up")
                }
                .foregroundStyle(.cyan)
            }

            Spacer()
        }
        .onReceive(session.$state, perform: { state in
            if case let .signedOut(registered) = state, let isRegistered = registered {
                vm.presentAlertForRegistration(status: isRegistered)
                if isRegistered {
                    vm.selectedSignInType = .signIn
                }
            }
        })
        .alert(item: $vm.alert) { alert in
            Alert(
                title: Text(alert.title),
                message: Text(alert.message),
                dismissButton: .default(Text("OK"))
            )
        }
        .padding()
    }
}

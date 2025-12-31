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

            VStack {
                Picker("SignInType", selection: $vm.selectedSignInType) {
                    ForEach(SignInType.allCases) { type in
                        Text(type.rawValue.capitalized)
                    }
                }
            }
            .pickerStyle(.segmented)

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

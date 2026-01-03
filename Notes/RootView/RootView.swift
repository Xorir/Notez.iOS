//
//  ContentView.swift
//  Notes
//
//  Created by Erman Maris on 12/30/25.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject private var session: SessionStore
    
    var body: some View {
        Group {
            switch session.state {
            case .loading:
                ProgressView("Loading ...")
                    .padding()
            case .signedOut:
                SignInView()
            case .signedIn:
                MainTabView()
            }
        }
        .animation(.default, value: session.state)
    }
}

#Preview {
    RootView()
}

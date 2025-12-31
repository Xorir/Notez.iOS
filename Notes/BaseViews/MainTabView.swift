//
//  MainTabView.swift
//  Notes
//
//  Created by Erman Maris on 12/31/25.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var session: SessionStore

    var body: some View {
        TabView {
            NavigationStack {
                VStack(spacing: 12) {
                    Text("Main Screen")
                    Button("Sign Out") { session.signOut() }
                }
                .padding()
            }
            .tabItem { Label("Home", systemImage: "house") }
        }
    }
}

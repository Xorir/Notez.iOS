//
//  MainTabView.swift
//  Notes
//
//  Created by Erman Maris on 12/31/25.
//

import SwiftUI

enum Tab {
    case home, notes, settings
}


struct MainTabView: View {
    @EnvironmentObject private var session: SessionStore
    @State private var selectedTab: Tab = .home

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(Tab.home)

            NotesView()
                .tabItem {
                    Label("Notes", systemImage: "note.text")
                }
                .tag(Tab.notes)

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
                .tag(Tab.settings)
        }
    }
}

struct HomeView: View {
    var body: some View {
        NavigationStack {
            Text("Home Screen")
                .navigationTitle("Home")
        }
    }
}

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            Text("Settings Screen")
                .navigationTitle("Settings")
        }
    }
}


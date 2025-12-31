//
//  NotesApp.swift
//  Notes
//
//  Created by Erman Maris on 12/30/25.
//

import SwiftUI

@main
struct NotesApp: App {
    @StateObject private var session = SessionStore()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(session)
                .task {
                    await session.restoreSession()
                }
        }
    }
}

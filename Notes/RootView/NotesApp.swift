//
//  NotesApp.swift
//  Notes
//
//  Created by Erman Maris on 12/30/25.
//

import SwiftUI

@main
struct NotesApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var session = SessionStore()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(session)
                .task {
                    await session.restoreSession()
                    
                    // FaceId code:
                    //                    do {
                    //                        let ok = try await BiometricAuth().authenticate(
                    //                            reason: "Unlock access to your account"
                    //                        )
                    //                        await session.restoreSession()
                    //                    } catch {
                    //                        Logger.shared.debug("FaceID error: \((error as NSError).localizedDescription)")
                    //                    }
                }
        }
    }
}

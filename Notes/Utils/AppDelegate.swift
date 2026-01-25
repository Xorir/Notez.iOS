//
//  AppDelegate.swift
//  Notes
//
//  Created by Erman Maris on 1/19/26.
//

import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        return true
    }

    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        Logger.shared.debug("APNs device token: \(tokenString)")
        UserSession.shared.apnsToken = tokenString
        // Send tokenString to your backend and associate with the logged-in user
        // BackendAPI.savePushToken(tokenString)
    }

    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register:", error)
    }
}

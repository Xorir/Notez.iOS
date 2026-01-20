//
//  PushNotificationManager.swift
//  Notes
//
//  Created by Erman Maris on 1/19/26.
//

import UserNotifications
import UIKit

final class PushNotificationManager: NSObject {
    static let shared = PushNotificationManager()

    func requestAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self

        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error:", error)
                return
            }

            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }

            print("Permission granted:", granted)
        }
    }
}

extension PushNotificationManager: UNUserNotificationCenterDelegate {
    // Foreground presentation (when app is open)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }

    // User tapped the notification
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print("Tapped notification userInfo:", userInfo)
        completionHandler()
    }
}

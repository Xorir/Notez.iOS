//
//  UserSession.swift
//  Notes
//
//  Created by Erman Maris on 1/19/26.
//

final class UserSession {

    static let shared = UserSession()
    private init() {}

    var userId: String?
    var email: String?
    var name: String?
    var authToken: String?
    var apnsToken: String?

    var isLoggedIn: Bool {
        return userId != nil && authToken != nil
    }

    func clear() {
        userId = nil
        email = nil
        name = nil
        authToken = nil
        apnsToken = nil
    }
}

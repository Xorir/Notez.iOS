//
//  Constants.swift
//  Notes
//
//  Created by Erman Maris on 12/31/25.
//

struct Constants {
    
    struct URLs {
        static let base = "https://notez-api-dev-ebbsgvc2fzd5akdq.canadacentral-01.azurewebsites.net"
    }
    
}

enum NoteHttpMethods: String, CaseIterable {
    case post
    case get
    case delete
    case update
    case patch
    
    var method: String {
        switch self {
        case .post:
            return "POST"
        case .delete:
            return "DELETE"
        case .get:
            return "GET"
        case .update:
            return "UPDATE"
        case .patch:
            return "PATCH"
        }
    }
}


enum NoteEndpoints: String, CaseIterable {
    case register
    case login
    case refresh
    case allNotes
    case createNote
    case identityUser
    
    var fullUrl: String {
        switch self {
        case .register:
            return Constants.URLs.base + "/register"
        case .login:
            return Constants.URLs.base + "/login"
        case .refresh:
            return Constants.URLs.base + "/refresh"
        case .allNotes:
            return Constants.URLs.base + "/api/notez"
        case .createNote:
            return Constants.URLs.base + "/api/notez"
        case .identityUser:
            return Constants.URLs.base + "/api/identity/user"
        }
    }
}


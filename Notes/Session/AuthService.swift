//
//  AuthService.swift
//  Notes
//
//  Created by Erman Maris on 12/30/25.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidResponse
    case httpStatus(Int, message: String?)
    case decodingFailed
    case encodingFailed

    var errorDescription: String? {
        switch self {
        case .invalidResponse: return "Invalid response."
        case .httpStatus(let code, let message): return "HTTP \(code): \(message ?? "No message")"
        case .decodingFailed: return "Failed to decode response."
        case .encodingFailed: return "Failed to encode request body."
        }
    }
}

struct CreateUserBody: Encodable {
    let email: String
    let password: String
}

struct SignInResult {
    let accessToken: String
    let user: User
}

protocol AuthServicing {
    func register(email: String, password: String) async throws -> Bool
    func signIn(email: String, password: String) async throws -> Bool
    func fetchMe(accessToken: String) async throws -> User
}

// Replace with real API implementation.
struct AuthService: AuthServicing {
    private let encoder = JSONEncoder()
    
    func register(email: String, password: String) async throws -> Bool {
        guard let url = URL(string: "https://notez-api-dev-ebbsgvc2fzd5akdq.canadacentral-01.azurewebsites.net/register") else { fatalError("Missing URL") }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let body = CreateUserBody(email: email, password: password)
        do {
            urlRequest.httpBody = try encoder.encode(body)
        } catch {
            throw NetworkError.encodingFailed
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("#### isRegistered data: \(data)")
                return false
            }
            return true
        }
        catch {
            return false
        }
    }
    
    func signIn(email: String, password: String) async throws -> Bool {
        guard let url = URL(string: "https://notez-api-dev-ebbsgvc2fzd5akdq.canadacentral-01.azurewebsites.net/login") else { fatalError("Missing URL") }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let body = CreateUserBody(email: email, password: password)
        do {
            urlRequest.httpBody = try encoder.encode(body)
        } catch {
            throw NetworkError.encodingFailed
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("#### isRegistered data: \(data)")
                return false
            }
            
            let decodedResponse = try JSONDecoder().decode(LoginModel.self, from: data)
            print("#### decodedResponse: \(decodedResponse)")
            return true
        }
        catch {
            return false
        }
    }
    
    func fetchMe(accessToken: String) async throws -> User {
        try await Task.sleep(nanoseconds: 200_000_000)
        return User(id: "1", email: "restored@example.com")
    }
}

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

struct CreateRefreshBody: Encodable {
    let refreshToken: String
}

struct SignInResult {
    let accessToken: String
    let user: User
}

protocol AuthServicing {
    func register(email: String, password: String) async throws -> Bool
    func signIn(email: String, password: String) async throws -> LoginModel?
    func refresh(token: String) async throws -> LoginModel?
}

// Replace with real API implementation.
struct AuthService: AuthServicing {
    private let encoder = JSONEncoder()
    
    func register(email: String, password: String) async throws -> Bool {
        guard let url = URL(string: NoteEndpoints.register.fullUrl) else { fatalError("Missing URL") }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = NoteHttpMethods.post.method
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let body = CreateUserBody(email: email, password: password)
        do {
            urlRequest.httpBody = try encoder.encode(body)
        } catch {
            throw NetworkError.encodingFailed
        }
        
        do {
            Logger.shared.debug(loggerReqType: .request)
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                Logger.shared.debug("register() data \(data)")
                return false
            }
            Logger.shared.debug(loggerReqType: .response)
            return true
        }
        catch {
            return false
        }
    }
    
    func signIn(email: String, password: String) async throws -> LoginModel? {
        guard let url = URL(string: NoteEndpoints.login.fullUrl) else { fatalError("Missing URL") }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = NoteHttpMethods.post.method
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let body = CreateUserBody(email: email, password: password)
        do {
            urlRequest.httpBody = try encoder.encode(body)
        } catch {
            throw NetworkError.encodingFailed
        }
        
        do {
            Logger.shared.debug(loggerReqType: .request)
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                Logger.shared.debug("signIn() data \(data)")
                return nil
            }
            
            let decodedResponse = try JSONDecoder().decode(LoginModel.self, from: data)
            Logger.shared.debug(loggerReqType: .response)
            Logger.shared.debug("signIn() decodedResponse \(decodedResponse)")
            return decodedResponse
        }
        catch {
            Logger.shared.debug("signIn() error \(error)")
            return nil
        }
    }
    
    func refresh(token: String) async throws -> LoginModel? {
        guard let url = URL(string: NoteEndpoints.refresh.fullUrl) else { fatalError("Missing URL") }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = NoteHttpMethods.post.method
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let body = CreateRefreshBody(refreshToken: token)
        do {
            urlRequest.httpBody = try encoder.encode(body)
        } catch {
            throw NetworkError.encodingFailed
        }
        
        do {
            Logger.shared.debug(loggerReqType: .request)
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                Logger.shared.debug("refresh() data failed")
                return nil
            }
            
            let decodedResponse = try JSONDecoder().decode(LoginModel.self, from: data)
            Logger.shared.debug(loggerReqType: .response)
            Logger.shared.debug("refresh() decodedResponse received")
            return decodedResponse
        }
        catch {
            Logger.shared.debug("refresh() error \(error)")
            return nil
        }
    }
}

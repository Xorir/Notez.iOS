//
//  NetworkManager.swift
//  Notes
//
//  Created by Erman Maris on 1/2/26.
//

import Foundation

struct NetworkManager {
    private let encoder = JSONEncoder()
    
    @MainActor func getAllNotes(token: String) async -> NotesModel? {
        guard let url = URL(string: NoteEndpoints.allNotes.fullUrl) else { fatalError("Missing URL") }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = NoteHttpMethods.get.method
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Authorization", forHTTPHeaderField: "Bearer \(token)")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                Logger.shared.debug("getAllNotes() data \(data)")
                return nil
            }
            
            let decodedResponse = try JSONDecoder().decode(NotesModel.self, from: data)
            return decodedResponse
        } catch {
            return nil
        }
    }
}

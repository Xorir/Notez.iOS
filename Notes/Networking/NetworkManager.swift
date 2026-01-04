//
//  NetworkManager.swift
//  Notes
//
//  Created by Erman Maris on 1/2/26.
//

import Foundation

@MainActor
class NetworkManager {
    private let encoder = JSONEncoder()
    
    func getAllNotes(token: String) async -> [NotesModel]? {
        guard let url = URL(string: NoteEndpoints.allNotes.fullUrl) else { fatalError("Missing URL") }
        
        Logger.shared.debug("getAllNotes() URL: \(url)")
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = NoteHttpMethods.get.method
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                Logger.shared.debug("getAllNotes() data \(data)")
                return nil
            }
            
            let decodedResponse = try JSONDecoder().decode([NotesModel]?.self, from: data)
            return decodedResponse
        } catch {
            Logger.shared.debug("getAllNotes() error: \(error)")
            return nil
        }
    }
    
    func createNote(note: CreateNoteModel,token: String) async throws -> Bool {
        guard let url = URL(string: NoteEndpoints.createNote.fullUrl) else { fatalError("Missing URL") }
        
        Logger.shared.debug("createNote() URL: \(url)")
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = NoteHttpMethods.post.method
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let noteModel = note
        
        do {
            urlRequest.httpBody = try encoder.encode(noteModel)
        } catch {
            throw NetworkError.encodingFailed
        }
        
        do {
            Logger.shared.debug(loggerReqType: .request)
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                Logger.shared.debug("createNote() data \(data)")
                return false
            }
            Logger.shared.debug(loggerReqType: .response)
            return true
        }
        catch {
            return false
        }
    }
    
}

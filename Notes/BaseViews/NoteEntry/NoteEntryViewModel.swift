//
//  NoteEntryViewModel.swift
//  Notes
//
//  Created by Erman Maris on 1/3/26.
//

import Foundation

@MainActor
final class NoteEntryViewModel: ObservableObject {
    let networkManager = NetworkManager()
    @Published var isNoteCreated: Bool = false
    
    func createNote(title: String, content: String, session: SessionStore) async {
        guard let accessToken = getToken(session: session) else { return }
        let note = getNoteData(title: title, content: content)
        
        do {
            let isNoteCreated = try await networkManager.createNote(note: note, token: accessToken)
            self.isNoteCreated = isNoteCreated
        } catch {
            self.isNoteCreated = false
        }        
    }
    
    func getNoteData(title: String, content: String) -> CreateNoteModel {
        let note = CreateNoteModel(title: title,
                                   content: content,
                                   createdAt: "",
                                   updatedAt: "",
                                   deletedAt: "",
                                   isPinned: false,
                                   name: "",
                                   description: "")
        
        return note
    }
    
    private func getToken(session: SessionStore) -> String? {
        do {
            if let token = try session.read(token: .accessToken) {
                return token
            }
            return nil
        } catch {
            Logger.shared.debug("getToken() failed")
            return nil
        }
    }
    
    
}

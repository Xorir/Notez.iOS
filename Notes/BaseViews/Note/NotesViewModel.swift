//
//  NotesViewModel.swift
//  Notes
//
//  Created by Erman Maris on 1/2/26.
//

import SwiftUI
import Combine

@MainActor
class NotesViewModel: ObservableObject {
    private let sessionStore: SessionStore
    let networkManager = NetworkManager()
    @Published var notes: [NotesModel] = []
    
    init(sessionStore: SessionStore) {
        self.sessionStore = sessionStore
    }
    
    func getAllNotes(session: SessionStore) async {
        guard let accessToken = getToken(session: session) else { return }
        if let notesModel = await networkManager.getAllNotes(token: accessToken) {
            self.notes = notesModel
        }
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
    
    func delete(at offsets: IndexSet) async {
        await deleteFromDB(offsets: offsets)
    }
    
    func deleteFromDB(offsets: IndexSet) async {
        Logger.shared.debug("IndexSet: \(offsets)")
        guard let accessToken = getToken(session: sessionStore) else { return }
        let notesToDelete = offsets.map { notes[$0] }
        
        guard let note = notesToDelete.first, let noteId = note.id else {
            Logger.shared.debug("Note has no ID")
            return
        }
        
        do {
            let isDeleted = try await networkManager.delete(noteId: noteId, token: accessToken)
            
            if isDeleted {
                notes.remove(atOffsets: offsets)
                Logger.shared.debug("delete() Succeeded")
            }
        } catch {
            Logger.shared.debug("delete() failed")
        }
        
    }
}

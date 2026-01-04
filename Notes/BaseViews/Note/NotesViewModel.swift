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
    let networkManager = NetworkManager()
    @Published var notes: [NotesModel] = []
    
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
}

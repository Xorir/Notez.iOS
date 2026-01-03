//
//  NotesViewModel.swift
//  Notes
//
//  Created by Erman Maris on 1/2/26.
//

import SwiftUI
import Combine

class NotesViewModel: ObservableObject {
    @Published var notes: [NotesModel] = []
    
    func getAllNotes() {
        
    }
    
    
}

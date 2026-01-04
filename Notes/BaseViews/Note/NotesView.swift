//
//  NotesView.swift
//  Notes
//
//  Created by Erman Maris on 1/2/26.
//

import SwiftUI

struct NotesView: View {
    @EnvironmentObject private var session: SessionStore
    @ObservedObject var viewModel = NotesViewModel()

    var body: some View {
        NavigationStack {
            Text("Notes Screen")
                .navigationTitle("Notes")
            List(viewModel.notes, id: \.id) { note in
                Text(note.title ?? "")
            }
        }
        .task {
            await viewModel.getAllNotes(session: session)
        }
    }
}

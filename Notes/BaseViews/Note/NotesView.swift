//
//  NotesView.swift
//  Notes
//
//  Created by Erman Maris on 1/2/26.
//

import SwiftUI

struct NotesView: View {
    @EnvironmentObject private var session: SessionStore
    @StateObject var viewModel: NotesViewModel

    var body: some View {
        NavigationStack {
            Text("Notes Screen")
                .navigationTitle("Notes")
            List {
                ForEach(viewModel.notes) { note in
                    Text(note.title ?? "")
                }
                .onDelete(perform: { offsets in
                    Task {
                        await viewModel.delete(at: offsets)
                    }
                })
            }
        }
        .task {
            await viewModel.getAllNotes(session: session)
        }
    }
}

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
            Text("-")
                .navigationTitle("Notes")
            List {
                ForEach(viewModel.notes) { note in
                    NavigationLink {
                        NoteDetailView(note: note)
                    } label: {
                        Text(note.title ?? "")
                    }
                }
                .onDelete(perform: { offsets in
                    Task {
                        await viewModel.delete(at: offsets)
                    }
                })
            }
        }
        .navigationDestination(for: NotesModel.self) { theNote in
            NoteDetailView(note: theNote)
        }
        .task {
            await viewModel.getAllNotes(session: session)
        }
    }
}

struct NoteDetailView: View {
    let note: NotesModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(note.title ?? "").font(.title2).bold()
            Text(note.content ?? "")
            Spacer()
        }
        .padding()
        .navigationTitle("Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}

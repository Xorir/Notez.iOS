//
//  NoteEntryView.swift
//  Notes
//
//  Created by Erman Maris on 1/3/26.
//

import SwiftUI

struct NoteEntryView: View {
    @EnvironmentObject private var session: SessionStore
    @ObservedObject var viewModel = NoteEntryViewModel()
    @State private var title: String = ""
    @State private var bodyText: String = ""

    var onSave: ((String, String) -> Void)? = nil

    var body: some View {
        NavigationStack {
            Form {
                Section("Title") {
                    TextField("Enter title", text: $title)
                        .textInputAutocapitalization(.sentences)
                        .submitLabel(.next)
                }

                Section("Note") {
                    TextField("Write your note...", text: $bodyText, axis: .vertical)
                        .lineLimit(5...12)
                        .textInputAutocapitalization(.sentences)
                }
            }
            .navigationTitle("New Note")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Clear") {
                        title = ""
                        bodyText = ""
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave?(title.trimmingCharacters(in: .whitespacesAndNewlines),
                                bodyText.trimmingCharacters(in: .whitespacesAndNewlines))
                        Task {
                            await viewModel.createNote(title: title, content: bodyText, session: session)
                        }
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
        .onReceive(viewModel.$isNoteCreated, perform: { isCreated in
            if let created = isCreated {
                viewModel.presentAlertForRegistration(status: created)
            }
        })
        .alert(item: $viewModel.alert) { alert in
            Alert(
                title: Text(alert.title),
                message: Text(alert.message),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

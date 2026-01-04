//
//  CreateNoteModel.swift
//  Notes
//
//  Created by Erman Maris on 1/3/26.
//

struct CreateNoteModel: Codable {
    let title: String
    let content: String
    let createdAt: String
    let updatedAt: String
    let deletedAt: String
    let isPinned: Bool
    let name: String
    let description: String
}

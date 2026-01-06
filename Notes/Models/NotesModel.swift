//
//  NotesModel.swift
//  Notes
//
//  Created by Erman Maris on 1/2/26.
//

struct NotesModel: Identifiable, Codable, Hashable {
    let id: Int?
    let title: String?
    let content: String?
    let updatedAt: String?
    let deletedAt: String?
    let isPinned: Bool?
    let name: String?
    let description: String?
    var tags: [String]? = []
}

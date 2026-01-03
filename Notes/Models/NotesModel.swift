//
//  NotesModel.swift
//  Notes
//
//  Created by Erman Maris on 1/2/26.
//

struct NotesModel: Identifiable, Decodable {
    let id: Int?
    let title: String?
    let content: String?
    let updatedAt: String?
    let deletedAt: String?
    let isPinned: Bool?
    let name: String?
    let description: Bool?
    var tags: [String]? = []
}

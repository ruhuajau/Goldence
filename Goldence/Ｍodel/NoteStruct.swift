//
//  NoteStruct.swift
//  Goldence
//
//  Created by 趙如華 on 2023/9/23.
//

import Foundation

struct GoldenNote {
    let id: String
    let bookTitle: String
    let type: String
    let title: String
    let cardContent: String
    var isPublic: Bool

    var dictionaryRepresentation: [String: Any] {
        return [
            "id": id,
            "bookTitle": bookTitle,
            "type": type,
            "title": title,
            "cardContent": cardContent,
            "is_public": isPublic
        ]
    }
}

//
//  NoteStruct.swift
//  Goldence
//
//  Created by 趙如華 on 2023/9/23.
//

import Foundation

struct GoldenNote {
    let bookTitle: String
    let type: String
    let title: String
    let cardContent: String

    var dictionaryRepresentation: [String: Any] {
        return [
            "bookTitle": bookTitle,
            "type": type,
            "title": title,
            "cardContent": cardContent
        ]
    }
}

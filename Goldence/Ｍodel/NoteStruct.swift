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
    var textContent: String? // Optional text content
    var imageData: Data? // Optional image data as Data

    var dictionaryRepresentation: [String: Any] {
        var dict: [String: Any] = [
            "id": id,
            "bookTitle": bookTitle,
            "type": type,
            "title": title,
            "cardContent": cardContent,
            "is_public": isPublic
        ]
        
        // Add textContent and imageData to the dictionary if they are present
        if let textContent = textContent {
            dict["textContent"] = textContent
        }
        
        if let imageData = imageData {
            dict["imageData"] = imageData
        }
        
        return dict
    }
}


//struct GoldenNote {
//    let id: String
//    let bookTitle: String
//    let type: String
//    let title: String
//    let cardContent: String
//    var isPublic: Bool
//
//    var dictionaryRepresentation: [String: Any] {
//        return [
//            "id": id,
//            "bookTitle": bookTitle,
//            "type": type,
//            "title": title,
//            "cardContent": cardContent,
//            "is_public": isPublic
//        ]
//    }
//}
//
//

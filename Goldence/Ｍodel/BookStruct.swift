//
//  BookStruct.swift
//  Goldence
//
//  Created by 趙如華 on 2023/9/14.
//

import Foundation

struct Books {
    let title: String
    let author: String
    let imageURL: URL?

    var dictionaryRepresentation: [String: Any] {
        var dictionary: [String: Any] = [
            "title": title,
            "author": author
        ]

        if let imageURL = imageURL {
            dictionary["imageURL"] = imageURL.absoluteString
        }

        return dictionary
    }
}

struct Book: Codable {
    let kind: String
    let totalItems: Int
    let items: [BookItem]
}

struct BookItem: Codable {
    let kind: String
    let id: String
    let etag: String
    let selfLink: String
    let volumeInfo: VolumeInfo
    let saleInfo: SaleInfo
    let accessInfo: AccessInfo
    let searchInfo: SearchInfo
}

struct VolumeInfo: Codable {
    let title: String
    let subtitle: String?
    let authors: [String]
    let publisher: String
    let publishedDate: String
    let description: String
    let industryIdentifiers: [IndustryIdentifier]
    let readingModes: ReadingModes
    let pageCount: Int
    let printType: String
    let categories: [String]
    let maturityRating: String
    let allowAnonLogging: Bool
    let contentVersion: String
    let panelizationSummary: PanelizationSummary
    let imageLinks: ImageLinks
    let language: String
    let previewLink: String
    let infoLink: String
    let canonicalVolumeLink: String
}

struct IndustryIdentifier: Codable {
    let type: String
    let identifier: String
}

struct ReadingModes: Codable {
    let text: Bool
    let image: Bool
}

struct PanelizationSummary: Codable {
    let containsEpubBubbles: Bool
    let containsImageBubbles: Bool
}

struct ImageLinks: Codable {
    let smallThumbnail: String
    let thumbnail: String
}

struct SaleInfo: Codable {
    let country: String
    let saleability: String
    let isEbook: Bool
}

struct AccessInfo: Codable {
    let country: String
    let viewability: String
    let embeddable: Bool
    let publicDomain: Bool
    let textToSpeechPermission: String
    let epub: EpubInfo
    let pdf: PdfInfo
    let webReaderLink: String
    let accessViewStatus: String
    let quoteSharingAllowed: Bool
}

struct EpubInfo: Codable {
    let isAvailable: Bool
}

struct PdfInfo: Codable {
    let isAvailable: Bool
}

struct SearchInfo: Codable {
    let textSnippet: String
}

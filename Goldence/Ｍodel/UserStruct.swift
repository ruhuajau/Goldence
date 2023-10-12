//
//  UserStruct.swift
//  Goldence
//
//  Created by 趙如華 on 2023/10/12.
//

import Foundation

struct User {
    var name: String
    let authorizationCode: String
    let identityToken: String
    let userIdentifier: String
    var bookshelfID: [String]?
    var noteID: String?
    var dictionaryRepresentation: [String: Any] {
        var dict: [String: Any] = [
            "name": name,
            "authorization_code": authorizationCode,
            "identity_token": identityToken,
            "user_identifier": userIdentifier
        ]
        return dict
    }
}

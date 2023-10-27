//
//  FirebaseAPIManager.swift
//  Goldence
//
//  Created by 趙如華 on 2023/10/23.
//

import Foundation
import Foundation
import FirebaseFirestore

class FirebaseAPIManager {
    static let shared = FirebaseAPIManager()
    let db = Firestore.firestore()

    func loadBookshelves(completion: @escaping ([Bookshelf]) -> Void) {
        // Retrieve the user's userIdentifier from UserDefaults
        guard let userIdentifier = UserDefaults.standard.string(forKey: "userIdentifier") else {
            print("UserIdentifier not found in UserDefaults")
            completion([])
            return
        }

        let usersCollection = db.collection("users")        
        // Get the user's document
        usersCollection.document(userIdentifier).getDocument { (document, error) in
            if let error = error {
                print("Error fetching user document: \(error.localizedDescription)")
                completion([])
                return
            }

            if let document = document, document.exists {
                if let bookshelfIDs = document["bookshelfIDs"] as? [String] {
                    self.fetchBookshelves(bookshelfIDs: bookshelfIDs, completion: completion)
                } else {
                    completion([])
                }
            } else {
                // If the user document doesn't exist, return an empty array
                completion([])
            }
        }
    }

    private func fetchBookshelves(bookshelfIDs: [String], completion: @escaping ([Bookshelf]) -> Void) {
        let bookshelvesCollection = db.collection("bookshelves")
        var fetchedBookshelves: [Bookshelf] = []

        let dispatchGroup = DispatchGroup()

        for bookshelfID in bookshelfIDs {
            dispatchGroup.enter()

            bookshelvesCollection.document(bookshelfID).addSnapshotListener { (bookshelfDocument, error) in
                defer {
                    dispatchGroup.leave()
                }

                if let error = error {
                    print("Error fetching bookshelf document: \(error.localizedDescription)")
                } else if let bookshelfDocument = bookshelfDocument, bookshelfDocument.exists {
                    if let title = bookshelfDocument["name"] as? String, let imageURL = bookshelfDocument["imageURL"] as? String {
                        let bookshelf = Bookshelf(bookshelfID: bookshelfID, title: title, imageURL: imageURL)
                        fetchedBookshelves.append(bookshelf)
                    }
                }
            }
        }

        dispatchGroup.notify(queue: .main) {
            // All bookshelves have been fetched, call the completion handler
            completion(fetchedBookshelves)
        }
    }
    func getBooksFromBookshelf(bookshelfID: String, completion: @escaping ([Books]) -> Void) {
            let bookshelvesCollection = db.collection("bookshelves")
            let bookshelfRef = bookshelvesCollection.document(bookshelfID)
            let booksCollection = bookshelfRef.collection("books")
            booksCollection.getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error fetching books: \(error.localizedDescription)")
                    completion([])
                    return
                }
                var books: [Books] = []
                for document in querySnapshot!.documents {
                    let data = document.data()
                    if let title = data["title"] as? String,
                       let author = data["author"] as? String,
                       let imageURLString = data["imageURL"] as? String,
                       let bookID = data["book_id"] as? String,
                       let imageURL = URL(string: imageURLString) {
                        let book = Books(bookID: bookID, title: title, author: author, imageURL: imageURL)
                        books.append(book)
                    }
                }
                completion(books)
            }
        }
}

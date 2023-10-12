//
//  BookListViewController.swift
//  Goldence
//
//  Created by 趙如華 on 2023/9/22.
//

import UIKit
import Firebase
import Kingfisher

class BookListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!
    var bookshelfID: String?
    var bookshelfName: String?
    var books: [Books] = []
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()

        let backButtonImage = UIImage(named: "Icons_24px_Back02") // Replace "Icons_24px_Back02" with your image's name
        let customBackButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(customBackAction))
        customBackButton.tintColor = UIColor.hexStringToUIColor(hex: "1f7a8c")
        // Set the custom back button as the left bar button item
        navigationItem.leftBarButtonItem = customBackButton
        collectionView.delegate = self
        collectionView.dataSource = self
        if let bookshelfName = bookshelfName {
            getBooksFromBookshelf(bookshelfName: bookshelfName) { (retrievedBooks) in
                self.books = retrievedBooks
                self.collectionView.reloadData()
            }
        }

    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Dequeue a cell and use optional binding to safely unwrap it
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookListCollectionViewCell", for: indexPath) as? BookListCollectionViewCell {
            let book = books[indexPath.row]
            cell.bookNameLabel.text = book.title
            cell.bookNameLabel.sizeToFit()
            cell.authorNameLabel.text = book.author
            cell.bookImageView.kf.setImage(with: book.imageURL)
            cell.bookImageView.layer.cornerRadius = 8
            return cell
        } else {
            return UICollectionViewCell()
        }
    }

    
    func findBookshelf(byName bookshelfName: String, completion: @escaping (DocumentSnapshot?) -> Void) {
        let bookshelvesCollection = db.collection("bookshelves")

        // Create a query to find the bookshelf with the specified name
        let query = bookshelvesCollection.whereField("name", isEqualTo: bookshelfName)

        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error querying bookshelves: \(error.localizedDescription)")
                completion(nil)
                return
            }

            // Check if any documents were found
            if let document = querySnapshot?.documents.first {
                completion(document)
            } else {
                // No matching document found
                completion(nil)
            }
        }
    }
    func getBooksFromBookshelf(bookshelfName: String, completion: @escaping ([Books]) -> Void) {
        findBookshelf(byName: bookshelfName) { (bookshelfDocument) in
            guard let bookshelfDocument = bookshelfDocument else {
                completion([])
                return
            }

            let booksCollection = bookshelfDocument.reference.collection("books")

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
    @objc func customBackAction() {

        self.navigationController?.popViewController(animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        let cellWidth = (collectionViewWidth - 25) / 2
        return CGSize(width: cellWidth, height: 370)

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "bookToCard" {
            if let destinationVC = segue.destination as? GoldenCardListViewController,
               let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first {
                let bookTitle = books[selectedIndexPath.row].title
                destinationVC.bookTitle = bookTitle
            }
        }
    }

}

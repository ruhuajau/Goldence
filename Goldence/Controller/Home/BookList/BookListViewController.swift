//
//  BookListViewController.swift
//  Goldence
//
//  Created by 趙如華 on 2023/9/22.
//

import UIKit
import Firebase
import Kingfisher

class BookListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var bookshelfName: String?
    var books: [Books] = []
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.hexStringToUIColor(hex: "f8f9fa")
        tableView.backgroundColor = UIColor.hexStringToUIColor(hex: "eaf4f4")
        // Create a custom back button with the image
        let backButtonImage = UIImage(named: "Icons_24px_Back02") // Replace "Icons_24px_Back02" with your image's name
        let customBackButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(customBackAction))
        customBackButton.tintColor = UIColor.hexStringToUIColor(hex: "1f7a8c")
        // Set the custom back button as the left bar button item
        navigationItem.leftBarButtonItem = customBackButton
        tableView.delegate = self
        tableView.dataSource = self
        if let bookshelfName = bookshelfName {
            getBooksFromBookshelf(bookshelfName: bookshelfName) { (retrievedBooks) in
                self.books = retrievedBooks
                self.tableView.reloadData()
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookListTableViewCell") as? BookListTableViewCell
        let book = books[indexPath.row]
        cell?.bookNameLabel.text = book.title
        cell?.bookNameLabel.sizeToFit()
        cell?.authorNameLabel.text = book.author
        cell?.bookImageView.kf.setImage(with: book.imageURL)
        return cell!
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
                       let imageURL = URL(string: imageURLString) {
                        let book = Books(title: title, author: author, imageURL: imageURL)
                        books.append(book)
                    }
                }

                completion(books)
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "bookToGoldence" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let bookTitle = books[indexPath.row].title
                if let destinationVC = segue.destination as? GoldenCardListViewController {
                    destinationVC.bookTitle = bookTitle
                }
            }
        }
    }
    @objc func customBackAction() {

        self.navigationController?.popViewController(animated: true)
    }
}

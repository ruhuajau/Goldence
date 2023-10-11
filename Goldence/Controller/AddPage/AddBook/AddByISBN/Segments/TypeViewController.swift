//
//  TypeViewController.swift
//  Goldence
//
//  Created by 趙如華 on 2023/9/14.
//

import UIKit
import Kingfisher
import Firebase
import FirebaseStorage

class TypeViewController: UIViewController {

    var bookshelfID: String?
    var bookName: String?
    var authorName: String?
    var imageURLString: String?
    
    @IBOutlet weak var isbnTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(bookshelfID)
        searchButton.layer.cornerRadius = 15
        saveButton.layer.cornerRadius = 15
        saveButton.isHidden = true
        // Do any additional setup after loading the view.
    }
    @IBAction func searchButtonTapped(_ sender: Any) {
        guard let isbn = isbnTextField.text, !isbn.isEmpty else {
            showAlert(title: "Error", message: "No ISBN")
            return
        }
        // Use the API manager to fetch book information
        GoogleBooksAPIManager.shared.searchBookByISBN(isbn: isbn) { result in
            switch result {
            case .success(let book):
                // Update the UI on the main thread
                DispatchQueue.main.async {
                    let bookItem = book.items.first
                    if let bookItem = bookItem {
                        let title = bookItem.volumeInfo.title
                        let authors = bookItem.volumeInfo.authors
                        self.titleLabel.text = title
                        self.authorLabel.text = authors.joined(separator: ", ")
                        if let imageUrlString = book.items.first?.volumeInfo.imageLinks.smallThumbnail {
                            if let imageUrl = URL(string: imageUrlString) {
                                self.bookImage.kf.setImage(with: imageUrl)
                                // Update the properties for saving
                                self.bookName = title
                                self.authorName = authors.joined(separator: ", ")
                                self.imageURLString = imageUrlString
                                self.saveButton.isHidden = false
                            }
                        }
                    }
                }
            case .failure(let error):
                print("Error fetching book information: \(error)")
                // Handle the error (e.g., show an error message to the user)
                    }
                }
    }
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let bookshelfID = bookshelfID,
                      let bookName = bookName,
                      let authorName = authorName,
                      let imageURL = imageURLString.flatMap({ URL(string: $0) }) else {
            showAlert(title: "Error", message: "No Book Data")
                    return
                }

                // Reference to the parent bookshelf document
                let bookshelfRef = Firestore.firestore().collection("bookshelves").document(bookshelfID)

                // Create a new book document within the specified bookshelf
                let bookRef = bookshelfRef.collection("books").document()

                // Create a Book instance
                let book = Books(title: bookName, author: authorName, imageURL: imageURL)

                // Save the book data to Firestore
                bookRef.setData(book.dictionaryRepresentation) { error in
                    if let error = error {
                        self.showAlert(title: "Error", message: "Error saving book data: \(error.localizedDescription)")
                    } else {
                        self.showAlert(title: "Success", message: "Book data saved successfully!")
                        // Reset the UI elements to their original state
                                    self.isbnTextField.text = ""
                                    self.titleLabel.text = ""
                                    self.authorLabel.text = ""
                                    self.bookImage.image = nil
                                    self.saveButton.isHidden = true
                    }
                }
    }
}

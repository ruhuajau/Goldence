//
//  AddByScanISBNViewController.swift
//  Goldence
//
//  Created by 趙如華 on 2023/9/21.
//
import UIKit
import Kingfisher
import Firebase
import FirebaseStorage

class BookResultViewController: UIViewController {
    var barcodeNumber: String?
    var bookshelfID: String?
    var bookName: String?
    var authorName: String?
    var imageURLString: String?
    weak var delegate: BookResultViewControllerDelegate?
    // Properties for UI elements
        let bookCoverImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit // Adjust content mode as needed
            imageView.layer.borderColor = UIColor.black.cgColor
            return imageView
        }()
        let titleLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont.boldSystemFont(ofSize: 20)
            label.textColor = UIColor.black
            label.textAlignment = .center
            label.layer.borderColor = UIColor.black.cgColor
            return label
        }()
        let authorLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont.systemFont(ofSize: 16) // Adjust font size as needed
            label.textColor = UIColor.gray // Adjust text color as needed
            label.textAlignment = .center
            return label
        }()
        // Create a dismiss button
        let saveButton: UIButton = {
            let button = UIButton(type: .system)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle("Save", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16) // Adjust font size as needed
            button.setTitleColor(UIColor.gray, for: .normal) // Adjust text color as needed
            return button
        }()
        // Create a dismiss button
        let dismissButton: UIButton = {
            let button = UIButton(type: .system)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle("Dismiss", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16) // Adjust font size as needed
            button.setTitleColor(UIColor.gray, for: .normal) // Adjust text color as needed
            return button
        }()
        override func viewDidLoad() {
            view.backgroundColor = .white
            setupUI()
            searchByISBN()
        }
    func setupUI() {
        // Create a vertical stack view
        let stackView = UIStackView(arrangedSubviews: [bookCoverImageView, titleLabel, authorLabel, saveButton])
        stackView.axis = .vertical
        stackView.spacing = 40
        stackView.translatesAutoresizingMaskIntoConstraints = false
        // Add the stack view to the view
        view.addSubview(stackView)
        // dismissButton
        view.addSubview(dismissButton)
        dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        // Set constraints for the stack view (adjust these constraints as needed)
        let centerXConstraint = stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let centerYConstraint = stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        let leadingConstraint = stackView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20)
        let trailingConstraint = stackView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20)

        // Activate the constraints
        NSLayoutConstraint.activate([
            centerXConstraint,
            centerYConstraint,
            leadingConstraint,
            trailingConstraint
        ])
        // Configure constraints for the dismiss button
        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            dismissButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    func searchByISBN() {
        guard let isbn = barcodeNumber else {
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
                                self.bookCoverImageView.kf.setImage(with: imageUrl)
                            // Update the properties for saving
                            self.bookName = title
                            self.authorName = authors.joined(separator: ", ")
                            self.imageURLString = imageUrlString
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
    @objc func dismissButtonTapped() {
        self.dismiss(animated: true) {
            // Call the delegate method when the view controller is dismissed
            self.delegate?.didDismissBookResultViewController()
        }
    }
    @objc func saveButtonTapped() {
        guard let bookshelfID = bookshelfID,
                      let bookName = bookName,
                      let authorName = authorName,
                      let imageURL = imageURLString.flatMap({ URL(string: $0) }) else {
                    showAlert(message: "Book information is missing.")
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
                        self.showAlert(message: "Error saving book data: \(error.localizedDescription)")
                    } else {
                        self.showAlert(message: "Book data saved successfully!")
                    }
                }
    }
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
}

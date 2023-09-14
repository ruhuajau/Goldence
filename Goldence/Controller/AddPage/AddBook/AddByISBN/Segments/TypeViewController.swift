//
//  TypeViewController.swift
//  Goldence
//
//  Created by 趙如華 on 2023/9/14.
//

import UIKit

class TypeViewController: UIViewController {

    @IBOutlet weak var isbnTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func searchButtonTapped(_ sender: Any) {
        guard let isbn = isbnTextField.text, !isbn.isEmpty else {
            showAlert(message: "isbn is missing.")
            return
        }
        // Use the API manager to fetch book information
        GoogleBooksAPIManager.shared.searchBookByISBN(isbn: isbn) { result in
            switch result {
            case .success(let book):
                // Update the UI on the main thread
                DispatchQueue.main.async {
                    print(book)
                    let bookItem = book.items.first
                    if let bookItem = bookItem {
                        let title = bookItem.volumeInfo.title
                        let authors = bookItem.volumeInfo.authors
                        self.titleLabel.text = title
                        self.authorLabel.text = authors.joined(separator: ", ")
                    }
                }
            case .failure(let error):
                print("Error fetching book information: \(error)")
                // Handle the error (e.g., show an error message to the user)
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

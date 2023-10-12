//
//  ViewController.swift
//  Goldence
//
//  Created by 趙如華 on 2023/9/13.
//

import UIKit
import Firebase
import Kingfisher

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    private var bookshelves: [Bookshelf] = []
    private let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        loadBookshelves()
        // Set the title text attributes for the navigation bar
        if let navigationBar = navigationController?.navigationBar {
            // Customize the title color
            navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        }

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "HomePageTableViewCell") as? HomePageTableViewCell {
            let bookshelf = bookshelves[indexPath.row]
            cell.bookshelfTitle.text = bookshelf.title
            if let imageUrl = URL(string: bookshelf.imageURL ?? "") {
                cell.bookshelfImage.kf.setImage(with: imageUrl)
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookshelves.count
    }
    func loadBookshelves() {
        // Retrieve the user's userIdentifier from UserDefaults
        guard let userIdentifier = UserDefaults.standard.string(forKey: "userIdentifier") else {
            print("UserIdentifier not found in UserDefaults")
            return
        }

        let db = Firestore.firestore()
        let usersCollection = db.collection("users")
        
        // Get the user's document
        usersCollection.document(userIdentifier).getDocument { (document, error) in
            if let error = error {
                print("Error fetching user document: \(error.localizedDescription)")
                return
            }

            if let document = document, document.exists {
                if let bookshelfIDs = document["bookshelfIDs"] as? [String] {
                    // Fetch bookshelves associated with bookshelfIDs
                    let bookshelvesCollection = db.collection("bookshelves")
                    self.bookshelves.removeAll() // Clear existing bookshelves

                    // Iterate through each bookshelfID and fetch the corresponding bookshelf document
                    for bookshelfID in bookshelfIDs {
                        bookshelvesCollection.document(bookshelfID).getDocument { (bookshelfDocument, error) in
                            if let error = error {
                                print("Error fetching bookshelf document: \(error.localizedDescription)")
                            } else if let bookshelfDocument = bookshelfDocument, bookshelfDocument.exists {
                                // Extract data from the bookshelf document
                                if let title = bookshelfDocument["name"] as? String, let imageURL = bookshelfDocument["imageURL"] as? String {
                                    let bookshelf = Bookshelf(bookshelfID: bookshelfID, title: title, imageURL: imageURL)
                                    self.bookshelves.append(bookshelf)
                                    self.tableView.reloadData() // Reload the table view
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "booksInShelf" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let bookshelfName = bookshelves[indexPath.row].title
                let bookshelfID = bookshelves[indexPath.row].bookshelfID
                if let destinationVC = segue.destination as? BookListViewController {
                    //destinationVC.bookshelfName = bookshelfName
                    destinationVC.bookshelfID = bookshelfID
                }
            }
        }
    }
}

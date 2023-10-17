//
//  AddPageViewController.swift
//  Goldence
//
//  Created by 趙如華 on 2023/9/14.
//

import UIKit
import Firebase
import Kingfisher

class SelectShelfViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var bookshelves: [Bookshelf] = []
    var selectedBookshelfName: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadBookshelves()
        if let navigationBar = navigationController?.navigationBar {
            // Customize the title color
            navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, .font: UIFont(name: "Zapfino", size: 15)]
        }

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            // Number of rows in section 0
            return 1
        } else if section == 1 {
            // Number of bookshelves in section 1
            return bookshelves.count
        }
        // Return 0 for other sections, or handle additional sections as needed
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if indexPath.section == 0 {
            // Configure the cell for the first section
            cell = tableView.dequeueReusableCell(withIdentifier: "NewShelfTableViewCell", for: indexPath)
            // Customize this cell for the first section
        } else {
            if let customCell = tableView.dequeueReusableCell(withIdentifier: "SelectShelfTableViewCell", for: indexPath) as? SelectShelfTableViewCell {
                // Cell is successfully casted to SelectShelfTableViewCell
                let bookShelf = bookshelves[indexPath.row]
                customCell.bookShelfName.text = bookShelf.title
                if let imageUrl = URL(string: bookShelf.imageURL ?? "") {
                    customCell.bookShelfImage.kf.setImage(with: imageUrl)
                }
                return customCell // Return the custom cell
            } else {
                // Handle the case where casting fails
                return UITableViewCell()
            }
        }
        return cell // Return the default cell outside of the if conditions
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
        usersCollection.document(userIdentifier).addSnapshotListener { (document, error) in
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
                        bookshelvesCollection.document(bookshelfID).addSnapshotListener { (bookshelfDocument, error) in
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
        if segue.identifier == "addBook" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let bookshelfID = bookshelves[indexPath.row].bookshelfID
                if let destinationVC = segue.destination as? AddBookViewController {
                    destinationVC.bookshelfID = bookshelfID
                }
            }
        }
    }
}

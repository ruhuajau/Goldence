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
    @IBOutlet weak var remindLabel: UILabel!
    private var bookshelves: [Bookshelf] = []
    private let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Create a custom view for the navigation bar background
                let customNavBarBackgroundView = UIView()
                customNavBarBackgroundView.backgroundColor = UIColor.clear
                // Add an image view to this custom background view
                let imageView = UIImageView(image: UIImage(named: "titleView"))
                imageView.contentMode = .scaleAspectFill
                imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 10) // Adjust the height as needed
                customNavBarBackgroundView.addSubview(imageView)
                // Create a label for the navigation item's title
                let titleLabel = UILabel()
                titleLabel.text = "Your Title"
                titleLabel.textColor = UIColor.white // Set the text color as needed
                titleLabel.font = UIFont.systemFont(ofSize: 30) // Adjust the font and size as needed
                titleLabel.sizeToFit()
                titleLabel.center = customNavBarBackgroundView.center
                // Add the title label to the custom background view
                customNavBarBackgroundView.addSubview(titleLabel)
                // Set the custom background view as the navigation bar's background
        
                navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
                navigationController?.navigationBar.shadowImage = UIImage()
                navigationController?.navigationBar.isTranslucent = true
                navigationController?.navigationBar.addSubview(customNavBarBackgroundView)
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
                                    
                                    // Check the count of bookshelves and show/hide the remindLabel accordingly
                                    if self.bookshelves.isEmpty {
                                        self.remindLabel.isHidden = false
                                    } else {
                                        self.remindLabel.isHidden = true
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                // If the user document doesn't exist, show the remindLabel
                self.remindLabel.isHidden = false
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

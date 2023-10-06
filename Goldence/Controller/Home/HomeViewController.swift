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
        let db = Firestore.firestore()
        let bookshelvesCollection = db.collection("bookshelves")
        bookshelvesCollection.addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("Error fetching bookshelves: \(error.localizedDescription)")
                return
            }
            self.bookshelves.removeAll()
            for document in querySnapshot!.documents {
                let data = document.data()
                if let title = data["name"] as? String, let imageURL = data["imageURL"] as? String {
                    let bookshelf = Bookshelf(title: title, imageURL: imageURL)
                    self.bookshelves.append(bookshelf)
                }
            }
            // Reload the table view with the updated data
            self.tableView.reloadData()
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "booksInShelf" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let bookshelfName = bookshelves[indexPath.row].title
                if let destinationVC = segue.destination as? BookListViewController {
                    destinationVC.bookshelfName = bookshelfName
                }
            }
        }
    }
}

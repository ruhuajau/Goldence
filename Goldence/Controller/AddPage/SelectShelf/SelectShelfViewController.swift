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
        FirebaseAPIManager.shared.loadBookshelves { [weak self] bookshelves in
            self?.bookshelves = bookshelves
            self?.tableView.reloadData()
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

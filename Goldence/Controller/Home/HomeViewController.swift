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
    private let apiManager = FirebaseAPIManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = UIImageView(image: UIImage(named: "GoldenceTitleView"))
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        loadBookshelves()
        // Set the title text attributes for the navigation bar
        if let navigationBar = navigationController?.navigationBar {
            // Customize the title color
            navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, .font: UIFont(name: "Zapfino", size: 15)]
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
        apiManager.loadBookshelves { [weak self] bookshelves in
            guard let self = self else { return }

            self.bookshelves = bookshelves
            self.tableView.reloadData()

            // Check the count of bookshelves and show/hide the remindLabel accordingly
            if self.bookshelves.isEmpty {
                self.remindLabel.isHidden = false
            } else {
                self.remindLabel.isHidden = true
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

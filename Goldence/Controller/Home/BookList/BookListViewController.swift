//
//  BookListViewController.swift
//  Goldence
//
//  Created by 趙如華 on 2023/9/22.
//

import UIKit
import Firebase
import Kingfisher

class BookListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var remindLabel: UILabel!
    private let apiManager = FirebaseAPIManager.shared
    var bookshelfID: String?
    //var bookshelfName: String?
    var books: [Books] = []
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        let backButtonImage = UIImage(named: "Icons_24px_Back02") // Replace "Icons_24px_Back02" with your image's name
        let customBackButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(customBackAction))
        customBackButton.tintColor = UIColor.hexStringToUIColor(hex: "1f7a8c")
        // Set the custom back button as the left bar button item
        navigationItem.leftBarButtonItem = customBackButton
        collectionView.delegate = self
        collectionView.dataSource = self
  
            getBooksFromBookshelf()
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Dequeue a cell and use optional binding to safely unwrap it
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookListCollectionViewCell", for: indexPath) as? BookListCollectionViewCell {
            let book = books[indexPath.row]
            cell.bookNameLabel.text = book.title
            cell.bookNameLabel.sizeToFit()
            cell.authorNameLabel.text = book.author
            cell.bookImageView.kf.setImage(with: book.imageURL)
            cell.bookImageView.layer.cornerRadius = 8
            return cell
        } else {
            return UICollectionViewCell()
        }
    }

    func getBooksFromBookshelf() {
        if let bookshelfID = bookshelfID {
            apiManager.getBooksFromBookshelf(bookshelfID: bookshelfID) { (retrievedBooks) in
                self.books = retrievedBooks
                self.collectionView.reloadData()
                self.remindLabel.isHidden = !self.books.isEmpty
            }
        } else {
            return
        }
        self.remindLabel.isHidden = !self.books.isEmpty

    }
    @objc func customBackAction() {

        self.navigationController?.popViewController(animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        let cellWidth = (collectionViewWidth - 25) / 2
        return CGSize(width: cellWidth, height: 400)

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "bookToCard" {
            if let destinationVC = segue.destination as? GoldenCardListViewController,
               let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first {
                let bookTitle = books[selectedIndexPath.row].title
                let bookID = books[selectedIndexPath.row].bookID
                destinationVC.bookTitle = bookTitle
                destinationVC.bookID = bookID
            }
        }
    }

}

//
//  ProfileViewController.swift
//  Goldence
//
//  Created by 趙如華 on 2023/10/10.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    @IBOutlet weak var analysisButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Fetch the user's name from Firebase and set it in the nameLabel
        if let userIdentifier = UserDefaults.standard.string(forKey: "userIdentifier") {
            fetchUserNameFromFirebase(userIdentifier: userIdentifier)
            print("UserIdentifier in UserDefaults")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        deleteButton.layer.cornerRadius = 8
        deleteButton.layer.borderColor = UIColor.red.cgColor
        deleteButton.layer.borderWidth = 1
        
        analysisButton.layer.cornerRadius = 8
        analysisButton.layer.borderColor = UIColor.hexStringToUIColor(hex: "6096ba").cgColor
        analysisButton.layer.borderWidth = 1
        // Do any additional setup after loading the view.
        if let navigationBar = navigationController?.navigationBar {
            // Customize the title color
            navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        }
    }
    func fetchUserNameFromFirebase(userIdentifier: String) {
            let usersCollection = Firestore.firestore().collection("users")
            let userDocRef = usersCollection.document(userIdentifier)

            userDocRef.addSnapshotListener { [weak self] (document, error) in
                guard let self = self else { return }
                if let document = document, document.exists {
                    if let userData = document.data(),
                       let userName = userData["name"] as? String {
                        // Update the nameLabel with the fetched user name
                        self.nameLabel.text = userName
                        print(userName)
                    }
                } else {
                    // Handle the case where the user document doesn't exist in Firebase
                    print("User document not found in Firebase.")
                    self.nameLabel.text = "User"
                }
            }
        }
    @IBAction func deleteButtonTapped(_ sender: Any) {
        // Retrieve the userIdentifier from UserDefaults
            if let userIdentifier = UserDefaults.standard.string(forKey: "userIdentifier") {
                let db = Firestore.firestore()
                let usersCollection = db.collection("users")
                // Reference to the user document
                let userDocRef = usersCollection.document(userIdentifier)
                userDocRef.getDocument { (document, error) in
                    if let error = error {
                        print("Error fetching user document: \(error.localizedDescription)")
                        return
                    }
                    if let document = document, document.exists {
                        // Check if bookshelfIDs and noteIDs arrays exist
                        if let bookshelfIDs = document["bookshelfIDs"] as? [String],
                           let noteIDs = document["noteIDs"] as? [String] {
                            let batch = db.batch() // Create a batch for multiple deletes
                            // Delete user's bookshelves
                            let bookshelvesCollection = db.collection("bookshelves")
                            for bookshelfID in bookshelfIDs {
                                let bookshelfRef = bookshelvesCollection.document(bookshelfID)
                                batch.deleteDocument(bookshelfRef)
                            }
                            // Delete user's notes
                            let notesCollection = db.collection("notes")
                            for noteID in noteIDs {
                                let noteRef = notesCollection.document(noteID)
                                batch.deleteDocument(noteRef)
                            }
                            // Delete the user document
                            batch.deleteDocument(userDocRef)
                            // Commit the batch operation
                            batch.commit { (error) in
                                if let error = error {
                                    print("Error deleting user data: \(error.localizedDescription)")
                                } else {
                                    // Remove userIdentifier from UserDefaults
                                    UserDefaults.standard.removeObject(forKey: "userIdentifier")
                                    self.navigationController?.popViewController(animated: true)
                                }
                            }
                        } else {
                            // If the arrays don't exist, delete only the user document
                            userDocRef.delete { (error) in
                                if let error = error {
                                    print("Error deleting user data: \(error.localizedDescription)")
                                } else {
                                    // Remove userIdentifier from UserDefaults
                                    UserDefaults.standard.removeObject(forKey: "userIdentifier")
                                    self.navigationController?.popViewController(animated: true)
                                }
                            }
                        }
                    }
                }
            }
    }
}

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
    @IBOutlet weak var logOutButton: UIButton!
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
        logOutButton.layer.cornerRadius = 8
        logOutButton.layer.borderColor = UIColor.black.cgColor
        logOutButton.layer.borderWidth = 1
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
        // Create an alert controller
            let alertController = UIAlertController(
                title: "Confirm Deletion",
                message: "Are you sure you want to delete your account? This action cannot be undone.",
                preferredStyle: .alert
            )            
            // Add a cancel action
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alertController.addAction(cancelAction)
            // Add a delete action
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
                // Delete the data when the user confirms
                self?.deleteUserData()
            }
            alertController.addAction(deleteAction)
            // Present the alert controller
            present(alertController, animated: true)
    }
    func deleteUserData(){
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
                            // Iterate over each bookshelf
                            for bookshelfID in bookshelfIDs {
                                // Delete the books within the bookshelf
                                let booksCollectionRef = db.collection("bookshelves").document(bookshelfID).collection("books")
                                self.deleteBooksInCollection(collectionReference: booksCollectionRef)
                                // Delete the bookshelf document
                                let bookshelfRef = db.collection("bookshelves").document(bookshelfID)
                                self.deleteDocument(documentReference: bookshelfRef)
                            }
                            // Iterate over each note and delete it
                            let notesCollection = db.collection("notes")
                            for noteID in noteIDs {
                                let noteRef = notesCollection.document(noteID)
                                self.deleteDocument(documentReference: noteRef)
                            }
                        }
                        // Delete the user document
                        self.deleteDocument(documentReference: userDocRef)
                        // Remove userIdentifier from UserDefaults
                        UserDefaults.standard.removeObject(forKey: "userIdentifier")
                        // Transition to the WelcomeViewController
                        if let logInVC = self.storyboard?.instantiateViewController(withIdentifier: "LogInViewController") as? LogInViewController {
                            logInVC.modalPresentationStyle = .fullScreen
                            self.present(logInVC, animated: true)
                        }

                    }
                }
            }
    }
    // Helper function to delete documents in a collection
    func deleteBooksInCollection(collectionReference: CollectionReference) {
        collectionReference.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching documents in collection: \(error.localizedDescription)")
                return
            }
            for document in querySnapshot?.documents ?? [] {
                self.deleteDocument(documentReference: document.reference)
            }
        }
    }
    // Helper function to delete a document
    func deleteDocument(documentReference: DocumentReference) {
        documentReference.delete { error in
            if let error = error {
                print("Error deleting document: \(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func logOutButtonTapped(_ sender: Any) {
        // Remove userIdentifier from UserDefaults
        UserDefaults.standard.removeObject(forKey: "userIdentifier")
        // Transition to the WelcomeViewController
        if let logInVC = self.storyboard?.instantiateViewController(withIdentifier: "LogInViewController") as? LogInViewController {
            logInVC.modalPresentationStyle = .fullScreen
            self.present(logInVC, animated: true)
        }

    }
    
}

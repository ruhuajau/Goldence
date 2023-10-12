//
//  GoldenCardListViewController.swift
//  Goldence
//
//  Created by 趙如華 on 2023/9/23.
//

import UIKit
import Firebase

class GoldenCardListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GoldenCardTableViewCellDelegate {
    @IBOutlet weak var tableView: UITableView!
    var bookTitle: String?
    var noteId: String?
    var notes: [GoldenNote] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Create a custom back button with the image
        let backButtonImage = UIImage(named: "Icons_24px_Back02") // Replace "Icons_24px_Back02" with your image's name
        let customBackButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(customBackAction))
        customBackButton.tintColor = UIColor.hexStringToUIColor(hex: "1f7a8c")

        // Set the custom back button as the left bar button item
        navigationItem.leftBarButtonItem = customBackButton
        tableView.delegate = self
        tableView.dataSource = self
        loadNotesForBook()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return notes.count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell // Declare cell with an initial value
        if indexPath.section == 0 {
            if let addCardCell = tableView.dequeueReusableCell(withIdentifier: "AddNewCardTableViewCell", for: indexPath) as? AddNewCardTableViewCell {
                addCardCell.selectionStyle = .none
                addCardCell.addCardImage.layer.cornerRadius = 40
                cell = addCardCell // Assign the cell
            } else {
                cell = UITableViewCell() // Assign a default cell if the cast fails
            }
        } else {
            if let goldenCardCell = tableView.dequeueReusableCell(withIdentifier: "GoldenCardTableViewCell", for: indexPath) as? GoldenCardTableViewCell {
                let note = notes[indexPath.row]
                goldenCardCell.selectionStyle = .none
                goldenCardCell.goldenceTitle.text = "——\(note.title)"
                goldenCardCell.goldenceContent.text = note.cardContent
                goldenCardCell.noteId = note.noteID
                goldenCardCell.delegate = self
                cell = goldenCardCell // Assign the cell
            } else {
                cell = UITableViewCell() // Assign a default cell if the cast fails
            }
        }
        
        return cell // Return the assigned cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNewGoldence" {
            if let indexPath = tableView.indexPathForSelectedRow {
                if let destinationVC = segue.destination as? NewGoldenceViewController {
                    destinationVC.bookTitle = bookTitle
                }
            }
        } else if segue.identifier == "editGoldence" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let noteId = notes[indexPath.row].noteID
                if let destinationVC = segue.destination as? EditGoldenCardContent {
                    destinationVC.noteId = noteId
                }
            }
        }
    }

    func loadNotesForBook() {
        // Check if a valid bookTitle is available
        guard let bookTitle = bookTitle else {
            return
        }
        // Reference to the Firestore collection "note"
        let notesCollection = Firestore.firestore().collection("notes")
        // Create a query to filter notes by bookTitle
        let query = notesCollection.whereField("book_title", isEqualTo: bookTitle)
        // Fetch documents based on the query
        query.addSnapshotListener { [weak self] (querySnapshot, error) in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching notes: \(error.localizedDescription)")
                return
            }
            // Clear the existing notes array
            self.notes.removeAll()
            // Iterate through the documents and populate the notes array
            for document in querySnapshot!.documents {
                let data = document.data()
                let title = data["title"] as? String ?? "" // Use the nil coalescing operator to handle potential nil values
                let cardContent = data["cardContent"] as? String ?? ""
                let id = data["note_id"] as? String ?? ""
                let note = GoldenNote(noteID: id, bookTitle: bookTitle, type: "book", title: title, cardContent: cardContent, isPublic: false)
                self.notes.append(note)
            }

            // Reload the table view to display the notes
            self.tableView.reloadData()
        }
    }
    func shareButtonTapped(noteId: String) {
        if let noteIndex = notes.firstIndex(where: { $0.noteID == noteId }) {
            var updatedNote = notes[noteIndex]
            updatedNote.isPublic = true
            // Update the Firebase document with the new is_public value
            let db = Firestore.firestore()
            let notesCollection = db.collection("notes")
            // Assuming your documents have a unique identifier, you can use it to update the document
            let documentId = updatedNote.noteID  // No need for optional binding here
            let noteDocumentRef = notesCollection.document(documentId)
            noteDocumentRef.updateData(["is_public": true]) { error in
                if let error = error {
                    print("Error updating document: \(error.localizedDescription)")
                } else {
                    self.showAlert(title: "Success", message: "Upload Successfully!")
                    print("Document updated successfully.")
                }
            }
        }
    }
    @objc func customBackAction() {

        self.navigationController?.popViewController(animated: true)
    }

    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

}



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
    var notes: [GoldenNote] = []
    override func viewDidLoad() {
        super.viewDidLoad()
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
        return 150
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "AddGoldenCardCell", for: indexPath)
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "GoldenCardTableViewCell", for: indexPath) as? GoldenCardTableViewCell {
                let note = notes[indexPath.row]
                cell.goldenceTitle.text = note.title
                cell.goldenceContent.text = note.cardContent
                cell.noteId = note.id
                cell.delegate = self
                return cell
            } else {
                return UITableViewCell()
            }
        }
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNewGoldence" {
            if let indexPath = tableView.indexPathForSelectedRow {
                if let destinationVC = segue.destination as? NewGoldenceViewController {
                    destinationVC.bookTitle = bookTitle
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
        let notesCollection = Firestore.firestore().collection("note")
        // Create a query to filter notes by bookTitle
        let query = notesCollection.whereField("bookTitle", isEqualTo: bookTitle)
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
                let id = data["id"] as? String ?? ""
                let note = GoldenNote(id: id, bookTitle: bookTitle, type: "book", title: title, cardContent: cardContent, isPublic: false)
                self.notes.append(note)
            }

            // Reload the table view to display the notes
            self.tableView.reloadData()
        }
    }
    func shareButtonTapped(noteId: String) {
        if let noteIndex = notes.firstIndex(where: { $0.id == noteId }) {
            var updatedNote = notes[noteIndex]
            updatedNote.isPublic = true
            
            // Update the Firebase document with the new is_public value
            let db = Firestore.firestore()
            let notesCollection = db.collection("note")
            
            // Assuming your documents have a unique identifier, you can use it to update the document
            let documentId = updatedNote.id  // No need for optional binding here
            
            let noteDocumentRef = notesCollection.document(documentId)
            
            noteDocumentRef.updateData(["is_public": true]) { error in
                if let error = error {
                    print("Error updating document: \(error.localizedDescription)")
                } else {
                    print("Document updated successfully.")
                }
            }
        }
    }

    }



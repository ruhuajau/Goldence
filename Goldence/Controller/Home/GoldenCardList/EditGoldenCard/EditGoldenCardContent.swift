//
//  EditGoldenCardContent.swift
//  Goldence
//
//  Created by 趙如華 on 2023/10/31.
//

import UIKit
import Firebase

class EditGoldenCardContent: UIViewController {
    
    var noteId: String?
    let db = Firestore.firestore()
    
    @IBOutlet weak var lookNote: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let backButtonImage = UIImage(named: "Icons_24px_Back02") // Replace "Icons_24px_Back02" with your image's name
        let customBackButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(customBackAction))
        customBackButton.tintColor = UIColor.hexStringToUIColor(hex: "1f7a8c")

        // Set the custom back button as the left bar button item
        navigationItem.leftBarButtonItem = customBackButton

        editButton.layer.cornerRadius = 8
        lookNote.layer.cornerRadius = 8
        updateTitleContent()
        contentTextView.layer.borderWidth = 1
        contentTextView.layer.borderColor = UIColor.black.cgColor
        contentTextView.layer.cornerRadius = 8
            }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditGoldenceNote" {
            if let destinationVC = segue.destination as? EditNoteViewController {
                destinationVC.noteId = noteId
            }
        }
    }
    @objc func customBackAction() {

        self.navigationController?.popViewController(animated: true)
    }

    func updateTitleContent() {
        // Check if noteId is not nil
                if let noteId = noteId {
                    // Fetch the note document with the given noteId
                    let notesRef = db.collection("notes").document(noteId)
                    notesRef.addSnapshotListener { [weak self] (document, error) in
                        if let error = error {
                            print("Error fetching note document: \(error.localizedDescription)")
                        } else if let document = document, document.exists {
                            // Parse the note data
                            if let title = document["title"] as? String,
                               let cardContent = document["cardContent"] as? String {
                                // Update the UI elements with note data
                                self?.titleTextField.text = title
                                self?.contentTextView.text = cardContent
                            } else {
                                print("Note document is missing title or cardContent field.")
                            }
                        } else {
                            print("Note document with ID \(noteId) does not exist.")
                        }
                    }
                }
            }
    @IBAction func updateButtonTapped(_ sender: Any) {
        // Check if noteId is not nil
            if let noteId = noteId {
                // Get the updated title and content from the text fields
                guard let updatedTitle = titleTextField.text, !updatedTitle.isEmpty,
                      let updatedContent = contentTextView.text, !updatedContent.isEmpty else {
                    // Handle case where title or content is empty
                    print("Title and content cannot be empty.")
                    return
                }

                // Reference to the note document
                let noteRef = db.collection("notes").document(noteId)

                // Update the title and content in the Firestore document
                noteRef.updateData([
                    "title": updatedTitle,
                    "cardContent": updatedContent
                ]) { error in
                    if let error = error {
                        print("Error updating note document: \(error.localizedDescription)")
                    } else {
                        // Update successful
                        print("Note document updated successfully.")
                        // Show an alert to inform the user of the successful update
                            let alertController = UIAlertController(title: "Update Successful", message: "The note has been updated.", preferredStyle: .alert)
                            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
    }
}


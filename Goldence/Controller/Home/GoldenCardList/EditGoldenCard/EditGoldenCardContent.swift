//
//  EditGoldenCardContent.swift
//  Goldence
//
//  Created by 趙如華 on 2023/10/2.
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
        editButton.layer.cornerRadius = 8
        saveButton.layer.cornerRadius = 8
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
    func updateTitleContent() {
        // Check if noteId is not nil
                if let noteId = noteId {
                    // Fetch the note document with the given noteId
                    let notesRef = db.collection("note").document(noteId)
                    notesRef.getDocument { [weak self] (document, error) in
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
    }


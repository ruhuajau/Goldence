//
//  NewGoldenceViewController.swift
//  Goldence
//
//  Created by 趙如華 on 2023/9/23.
//

import UIKit
import Firebase
import FirebaseStorage

class NewGoldenceViewController: UIViewController, UIKeyInput {
    func deleteBackward() {
        
    }
    
    var hasText: Bool = false
    @IBOutlet weak var cardTitleTextField: UITextField!
    @IBOutlet weak var cardContentTextView: UITextView!
    let db = Firestore.firestore()

    var bookTitle: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        let button = UIButton.init(frame: CGRect(x: 270, y: 170, width: 100, height: 40))
                if #available(iOS 15.0, *), self.canPerformAction(#selector(UIResponder.captureTextFromCamera(_:)), withSender: self) {
            print("support live text")
            button.addTarget(self, action: #selector(UIResponder.captureTextFromCamera(_:)), for: .touchUpInside)
        } else {
            print("this device is not support live text")
        }
        button.backgroundColor = .blue
        button.setTitle("一鍵掃描", for: .normal)
        view.addSubview(button)
    }
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = cardTitleTextField.text, !title.isEmpty,
              let cardContent = cardContentTextView.text, !cardContent.isEmpty else {
                    // Show an error message if either title or cardContent is missing
                    showAlert(message: "Please fill in both the title and card content.")
                    return
                }
            let newDocumentID = db.collection("notes").document()
                // Create a GoldenNote instance
        let goldenNote = GoldenNote(id: newDocumentID.documentID ?? "", bookTitle: bookTitle ?? "", type: "book", title: title, cardContent: cardContent, isPublic: false)
                // Reference to the "note" collection
                let notesCollection = db.collection("note")
                // Add the GoldenNote data to the "note" collection
        notesCollection.document(newDocumentID.documentID).setData(goldenNote.dictionaryRepresentation) { error in
                    if let error = error {
                        self.showAlert(message: "Error saving note: \(error.localizedDescription)")
                    } else {
                        // Successfully saved the note
                        self.showAlert(message: "Note saved successfully!")
                    }
                }
        navigationController?.popViewController(animated: true)
    }
    func showAlert(message: String) {
            let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
    func setupUI() {
        cardContentTextView.layer.borderWidth = 1
        cardContentTextView.layer.borderColor = UIColor.black.cgColor
        cardContentTextView.layer.cornerRadius = 8

    }
    func insertText(_ text: String) {
        //ORC scan text的 insert Text 按钮回调
        print("OCR 扫描到的文字是: \(text)")
        cardContentTextView.text = text
    }
}


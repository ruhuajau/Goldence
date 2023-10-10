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
        
    var hasText: Bool = false
    @IBOutlet weak var cardTitleTextField: UITextField!
    @IBOutlet weak var cardContentTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    let db = Firestore.firestore()

    var bookTitle: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.layer.cornerRadius = 15
        view.backgroundColor = UIColor.hexStringToUIColor(hex: "f8f9fa")
        // Create a custom back button with the image
        let backButtonImage = UIImage(named: "Icons_24px_Back02") // Replace "Icons_24px_Back02" with your image's name
        let customBackButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(customBackAction))
        customBackButton.tintColor = UIColor.hexStringToUIColor(hex: "1f7a8c")
        navigationItem.leftBarButtonItem = customBackButton
        setupUI()
        let button = UIButton.init(frame: CGRect(x: 270, y: 190, width: 100, height: 25))
                if #available(iOS 15.0, *), self.canPerformAction(#selector(UIResponder.captureTextFromCamera(_:)), withSender: self) {
            print("support live text")
            button.addTarget(self, action: #selector(UIResponder.captureTextFromCamera(_:)), for: .touchUpInside)
        } else {
            print("this device is not support live text")
        }
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.hexStringToUIColor(hex: "6096ba").cgColor
        button.layer.cornerRadius = 15
        button.setTitle("Scan text", for: .normal)
        button.setTitleColor(UIColor.hexStringToUIColor(hex: "6096ba"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        view.addSubview(button)
    }
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = cardTitleTextField.text, !title.isEmpty,
              let cardContent = cardContentTextView.text, !cardContent.isEmpty else {
                    // Show an error message if either title or cardContent is missing
            showAlert(title: "Error", message: "incomplete information")
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
                        self.showAlert(title: "Error", message: "Error saving note: \(error.localizedDescription)")
                    } else {
                        // Successfully saved the note
                        self.showAlert(title: "Success", message: "Store successfully!")
                    }
                }
        navigationController?.popViewController(animated: true)
    }
    func showAlert(title: String, message: String) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
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
    @objc func customBackAction() {

        self.navigationController?.popViewController(animated: true)
    }
    func deleteBackward() {
    }


}


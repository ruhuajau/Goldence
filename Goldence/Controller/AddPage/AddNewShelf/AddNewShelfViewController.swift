//
//  AddNewShelfViewController.swift
//  Goldence
//
//  Created by 趙如華 on 2023/9/21.
//

import UIKit
import Firebase
import FirebaseStorage

class AddNewShelfViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bookShelfImageView: UIImageView!
    var newBookImage: UIImage?
    @IBOutlet weak var saveButton: UIButton!
    let db = Firestore.firestore()
    let storage = Storage.storage()
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.layer.cornerRadius = 15
        view.backgroundColor = UIColor.hexStringToUIColor(hex: "f8f9fa")
        // Create a custom back button with the image
        let backButtonImage = UIImage(named: "Icons_24px_Back02") // Replace "Icons_24px_Back02" with your image's name
        let customBackButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(customBackAction))
        customBackButton.tintColor = UIColor.hexStringToUIColor(hex: "1f7a8c")

        // Set the custom back button as the left bar button item
        navigationItem.leftBarButtonItem = customBackButton
        titleTextField.delegate = self
        if let navigationBar = navigationController?.navigationBar {
            // Customize the title color
            navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        }

    }
    @IBAction func updateImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            // Create an action sheet with options
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            // Add the "Take Photo" option
            actionSheet.addAction(UIAlertAction(title: "Take a Photo", style: .default, handler: { _ in
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true)
            }))
            // Add the "Choose Photo" option
            actionSheet.addAction(UIAlertAction(title: "Upload a Photo", style: .default, handler: { _ in
                imagePicker.sourceType = .photoLibrary
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true)
            }))
            // Add a cancel option
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            // Present the action sheet
            present(actionSheet, animated: true)
    }
    @IBAction func saveButtonTapped(_ sender: Any) {
        if let bookShelfName = titleTextField.text, !bookShelfName.isEmpty
        {
            addData()
        } else {
                showAlert(message: "請輸入書櫃名稱並選擇一張圖片！")
            }
            navigationController?.popViewController(animated: true)
    }
    func addData() {
        guard let bookShelfName = titleTextField.text,
              let bookShelfImage = newBookImage,
              let userIdentifier = UserDefaults.standard.string(forKey: "userIdentifier")else {
            showAlert(message: "資訊有誤")
            return
        }
        
        // Generate a unique ID for the document
        let bookshelvesCollection = db.collection("bookshelves")
        // Create a document with the unique ID
        let documentID = bookshelvesCollection.document().documentID
        let documentRef = bookshelvesCollection.document(documentID)
        // Upload the image to Firebase Storage
        let imageRef = storage.reference().child("bookshelfImages/\(documentID).jpg")
        if let imageData = bookShelfImage.jpegData(compressionQuality: 0.5) {
            imageRef.putData(imageData, metadata: nil) { (_, error) in
                if let error = error {
                    self.showAlert(message: "Error uploading image: \(error.localizedDescription)")
                    return
                }
                // Once the image is uploaded, get the download URL
                imageRef.downloadURL { (url, error) in
                    if let error = error {
                        self.showAlert(message: "Error getting download URL: \(error.localizedDescription)")
                        return
                    }
                    // Save the bookshelf data to Firestore
                    let data: [String: Any] = [
                        "bookshelf_id": documentID,
                        "name": bookShelfName,
                        "imageURL": url?.absoluteString ?? ""
                    ]
                    documentRef.setData(data) { error in
                        if let error = error {
                            self.showAlert(message: "Error saving data: \(error.localizedDescription)")
                        } else {
                            self.showAlert(message: "Data saved successfully!")
                            self.showAlert(message: "Data saved successfully!")
                            // Update the user's document to include the bookshelfID in the array
                            let usersCollection = self.db.collection("users")
                            let userDocRef = usersCollection.document(userIdentifier)
                            
                            userDocRef.updateData(["bookshelfIDs": FieldValue.arrayUnion([documentID])]) { error in
                                if let error = error {
                                    self.showAlert(message: "Error updating user data: \(error.localizedDescription)")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
    }
    @objc func customBackAction() {

        self.navigationController?.popViewController(animated: true)
    }

}

extension AddNewShelfViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else {return}
        self.bookShelfImageView.image = selectedImage
        self.newBookImage = selectedImage
        dismiss(animated: true)
    }
}

extension AddNewShelfViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextField.resignFirstResponder()
        return true
    }
}

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
    let db = Firestore.firestore()
    let storage = Storage.storage()
    override func viewDidLoad() {
        super.viewDidLoad()

        titleTextField.delegate = self
    }
    @IBAction func updateImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            // Create an action sheet with options
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            // Add the "Take Photo" option
            actionSheet.addAction(UIAlertAction(title: "拍照", style: .default, handler: { _ in
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true)
            }))
            // Add the "Choose Photo" option
            actionSheet.addAction(UIAlertAction(title: "上傳圖片", style: .default, handler: { _ in
                imagePicker.sourceType = .photoLibrary
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true)
            }))
            // Add a cancel option
            actionSheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
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
              let bookShelfImage = newBookImage else {
            showAlert(message: "Invalid data")
            return
        }

        // Generate a unique ID for the document
        let documentID = UUID().uuidString
        // Reference to Firestore collection
        let bookshelvesCollection = db.collection("bookshelves")
        // Create a document with the unique ID
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
                        "name": bookShelfName,
                        "imageURL": url?.absoluteString ?? ""
                    ]
                    documentRef.setData(data) { error in
                        if let error = error {
                            self.showAlert(message: "Error saving data: \(error.localizedDescription)")
                        } else {
                            self.showAlert(message: "Data saved successfully!")
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

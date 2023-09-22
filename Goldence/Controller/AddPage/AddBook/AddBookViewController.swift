//
//  AddBookViewController.swift
//  Goldence
//
//  Created by 趙如華 on 2023/9/14.
//

import UIKit
import Firebase
import FirebaseStorage

class AddBookViewController: UIViewController {
    var bookshelfName: String?
    var bookshelfID: String?
    @IBOutlet weak var ISBNButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var authorTextField: UITextField!
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var addPhotoButton: UIButton!
    var newBookImage: UIImage?
    let db = Firestore.firestore()
    let storage = Storage.storage()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleTextField.delegate = self
        authorTextField.delegate = self
        print(bookshelfName)
    }

    @IBAction func updateImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "拍照", style: .default, handler: { _ in
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "上傳圖片", style: .default, handler: { _ in
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        present(actionSheet, animated: true)
    }
    @IBAction func saveBookButtonTapped(_ sender: Any) {
        if let bookName = titleTextField.text,
           let authorName = authorTextField.text,
           !bookName.isEmpty,
           !authorName.isEmpty,
           let bookshelfName = self.bookshelfName { // Check if bookshelfName is available
            findBookshelfID(byName: bookshelfName) { (bookshelfID) in
                if let bookshelfID = bookshelfID {
                    self.addData(bookshelfId: bookshelfID)
                } else {
                    self.showAlert(message: "Bookshelf not found.")
                }
            }
        } else {
            showAlert(message: "請填入完整資訊！")
        }
    }
    func addData(bookshelfId: String) {
            guard let bookName = titleTextField.text,
                  let bookAuthor = authorTextField.text,
                  let bookImage = newBookImage else {
                showAlert(message: "資訊有誤")
                return
            }

            // Reference to the parent bookshelf document
            let bookshelfRef = db.collection("bookshelves").document(bookshelfId)

            // Create a new book document within the specified bookshelf
            let bookRef = bookshelfRef.collection("books").document()

            // Upload the image to Firebase Storage
            let imageRef = storage.reference().child("bookImages/\(bookRef.documentID).jpg")
            if let imageData = bookImage.jpegData(compressionQuality: 0.5) {
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
                        // Save the book data to Firestore
                        let data: [String: Any] = [
                            "title": bookName,
                            "author": bookAuthor,
                            "imageURL": url?.absoluteString ?? ""
                        ]
                        bookRef.setData(data) { error in
                            if let error = error {
                                self.showAlert(message: "Error saving book data: \(error.localizedDescription)")
                            } else {
                                self.showAlert(message: "Book data saved successfully!")
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
    func findBookshelfID(byName bookshelfName: String, completion: @escaping (String?) -> Void) {
        let bookshelvesCollection = db.collection("bookshelves")
        
        // Create a query to find the bookshelf with the specified name
        let query = bookshelvesCollection.whereField("name", isEqualTo: bookshelfName)
        
        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error querying bookshelves: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            // Check if any documents were found
            if let document = querySnapshot?.documents.first {
                // Retrieve the documentID of the found bookshelf
                let bookshelfID = document.documentID
                completion(bookshelfID)
            } else {
                // No matching document found
                completion(nil)
            }
        }
    }
}

extension AddBookViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        self.bookImageView.image = selectedImage
        self.newBookImage = selectedImage
        dismiss(animated: true)
    }
}

extension AddBookViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == titleTextField {
            return authorTextField.becomeFirstResponder()
        } else {
            return textField.resignFirstResponder()
        }
    }
}

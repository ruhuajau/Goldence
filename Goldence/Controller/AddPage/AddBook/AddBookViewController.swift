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
    @IBOutlet weak var saveButton: UIButton!
    var newBookImage: UIImage?
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
        // Do any additional setup after loading the view.
        titleTextField.delegate = self
        authorTextField.delegate = self
        // Retrieve the bookshelfID in viewDidLoad
            if let bookshelfName = self.bookshelfName {
                findBookshelfID(byName: bookshelfName) { (bookshelfID) in
                    if let bookshelfID = bookshelfID {
                        self.bookshelfID = bookshelfID
                    } else {
                        print("Bookshelf not found.")
                    }
                }
            }
        if let navigationBar = navigationController?.navigationBar {
            // Customize the title color
            navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        }

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
                    let bookshelfID = self.bookshelfID { // Use the stored bookshelfID
                    addData(bookshelfId: bookshelfID)
                } else {
                    showAlert(title: "錯誤", message: "請填入完整資訊！")
            }
    }
    func addData(bookshelfId: String) {
            guard let bookName = titleTextField.text,
                  let bookAuthor = authorTextField.text,
                  let bookImage = newBookImage else {
                showAlert(title: "錯誤", message: "資訊不完整")
                return
            }

            // Reference to the parent bookshelf document
            let bookshelfRef = db.collection("bookshelves").document(bookshelfId)
 
            let bookRefCollection = bookshelfRef.collection("books")
            let bookID = bookRefCollection.document().documentID
            let bookRef = bookRefCollection.document(bookID)
            // Upload the image to Firebase Storage
            let imageRef = storage.reference().child("bookImages/\(bookRef.documentID).jpg")
            if let imageData = bookImage.jpegData(compressionQuality: 0.5) {
                imageRef.putData(imageData, metadata: nil) { (_, error) in
                    if let error = error {
                        self.showAlert(title: "錯誤", message: "Error uploading image: \(error.localizedDescription)")
                        return
                    }
                    // Once the image is uploaded, get the download URL
                    imageRef.downloadURL { (url, error) in
                        if let error = error {
                            self.showAlert(title: "錯誤", message: "Error getting download URL: \(error.localizedDescription)")
                            return
                        }
                        // Save the book data to Firestore
                        let data: [String: Any] = [
                            "book_id": bookID,
                            "title": bookName,
                            "author": bookAuthor,
                            "imageURL": url?.absoluteString ?? ""
                        ]
                        bookRef.setData(data) { error in
                            if let error = error {
                                self.showAlert(title: "錯誤", message: "Error saving book data: \(error.localizedDescription)")
                            } else {
                                self.showAlert(title: "成功", message: "儲存成功！")
                            }
                        }
                    }
                }
            }
        }
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "byISBN" {
            if let destinationVC = segue.destination as? AddByISBNViewController {
                destinationVC.bookshelfID = self.bookshelfID
            }
        }
    }
    @objc func customBackAction() {

        self.navigationController?.popViewController(animated: true)
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

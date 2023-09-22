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
           !authorName.isEmpty {
            addData()
        } else {
            showAlert(message: "請填入完整資訊！")
        }
    }
    func addData() {
        guard let bookName = titleTextField.text,
              let bookAuthor = authorTextField.text,
              let bookImage = newBookImage else {
            showAlert(message: "資訊有誤")
            return
        }
        
        
        
       
    }
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
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

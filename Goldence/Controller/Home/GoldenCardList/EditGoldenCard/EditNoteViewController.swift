//
//  EditNoteViewController.swift
//  Goldence
//
//  Created by 趙如華 on 2023/10/31.
//

import UIKit
import Firebase
import FirebaseStorage

class EditNoteViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImageEditingDelegate {
    
    var noteId: String?
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    let imagePicker = UIImagePickerController()
    var imageWidths: [NSTextAttachment: CGFloat] = [:]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.layer.cornerRadius = 8
        imagePicker.delegate = self
        // Add tap gesture recognizer to detect image taps
        // Add a custom UITapGestureRecognizer to the UITextView
        textView.isUserInteractionEnabled = true
        textView.layer.borderWidth = 1.0 // Set the border width
        textView.layer.borderColor = UIColor.hexStringToUIColor(hex: "6b9080").cgColor // Set the border color
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        textView.addGestureRecognizer(tapGestureRecognizer)
        // show what users save
        let attributedText = self.getAttributedTextFromUserDefault(key: self.noteId!)
        textView.attributedText = attributedText
        let backButtonImage = UIImage(named: "Icons_24px_Back02") // Replace "Icons_24px_Back02" with your image's name
        let customBackButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(customBackAction))
        customBackButton.tintColor = UIColor.hexStringToUIColor(hex: "1f7a8c")

        // Set the custom back button as the left bar button item
        navigationItem.leftBarButtonItem = customBackButton
        saveButton.layer.cornerRadius = 8

    }
    @objc func customBackAction() {

        self.navigationController?.popViewController(animated: true)
    }

    
    @IBAction func insertImage(_ sender: Any) {
        let alertController = UIAlertController(title: "Insert Image", message: "Choose an option", preferredStyle: .actionSheet)
        
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default) { (_) in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        let selectPhotoAction = UIAlertAction(title: "Select Photo", style: .default) { (_) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(takePhotoAction)
        alertController.addAction(selectPhotoAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            let imageSize = CGSize(width: textView.bounds.width, height: selectedImage.size.height * (textView.bounds.width / selectedImage.size.width))

            // Create an NSTextAttachment with the resized image
            let textAttachment = CustomTextAttachment()
            textAttachment.image = selectedImage
            textAttachment.bounds = CGRect(origin: .zero, size: imageSize)
            textAttachment.imageWidths = selectedImage.size.width // Set the image width


            // Store the image width in the dictionary
            imageWidths[textAttachment] = selectedImage.size.width

            // Create an attributed string with the attachment
            let imageAttributedString = NSAttributedString(attachment: textAttachment)

            // Insert the image into the UITextView
            textView.textStorage.insert(imageAttributedString, at: textView.selectedRange.location)
        }
        picker.dismiss(animated: true, completion: nil)
    }

    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: textView)
        let layoutManager = textView.layoutManager
        
        // Check if the tap location is valid
        let glyphIndex = layoutManager.glyphIndex(for: location, in: textView.textContainer, fractionOfDistanceThroughGlyph: nil)
        if glyphIndex < textView.textStorage.length {
            // Find the tapped character index in the UITextView
            let characterIndex = layoutManager.characterIndexForGlyph(at: glyphIndex)
            if characterIndex != NSNotFound {
                let textStorage = textView.textStorage
                let attributes = textStorage.attributes(at: characterIndex, effectiveRange: nil)
                
                // Check if an image attachment is tapped
                if let attachment = attributes[.attachment] as? NSTextAttachment, let image = attachment.image {
                    // An image was tapped; open ImageViewController
                    if let imageViewController = storyboard?.instantiateViewController(withIdentifier: "ImageViewController") as? ImageViewController {
                        imageViewController.selectedImage = image
                        imageViewController.modalPresentationStyle = .fullScreen
                        imageViewController.delegate = self
                        self.present(imageViewController, animated: true, completion: nil)
                    }
                }
            } else {
                // No image was tapped, allow text editing
                textView.isUserInteractionEnabled = true
                textView.becomeFirstResponder()
            }
        }
    }
    
    func imageEditingViewController(_ controller: ImageViewController, didFinishEditingImage editedImage: UIImage) {
        // Find the edited image attachment in the UITextView's textStorage
        let textStorage = textView.textStorage

        textStorage.enumerateAttribute(.attachment, in: NSMakeRange(0, textStorage.length), options: []) { (value, range, stop) in
            if let attachment = value as? NSTextAttachment, let image = attachment.image, image == controller.selectedImage {
                // Update the original attachment with the edited image
                attachment.image = editedImage

                // Retrieve and set the image width from the dictionary
                if let width = imageWidths[attachment] {
                    attachment.bounds.size.width = width
                    (attachment as? CustomTextAttachment)?.imageWidths = width // Update the image width in CustomTextAttachment
                }

                // Refresh the textView to display the edited image
                textView.layoutManager.ensureLayout(for: textView.textContainer)
                textView.setNeedsDisplay()

                stop.pointee = true // Stop the enumeration
            }
        }
    }

    @IBAction func saveButtonTapped(_ sender: Any) {
        // Take attributedText and save it
            if let noteId = noteId {
                self.saveAttributedTextToUserDefaults(attributedText: textView.attributedText, key: noteId)
            }
            
            // Get the navigation controller's view controllers stack
            if let viewControllers = navigationController?.viewControllers {
                // Check if there are at least two view controllers in the stack
                if viewControllers.count >= 2 {
                    // Get the last two view controllers
                    let targetViewController = viewControllers[viewControllers.count - 3]
                    
                    // Pop to the target view controller
                    navigationController?.popToViewController(targetViewController, animated: true)
                }
            }
    }
    
    func saveAttributedTextToUserDefaults(attributedText: NSAttributedString, key: String) {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: attributedText, requiringSecureCoding: false)
            UserDefaults.standard.setValue(data, forKey: key)
        } catch {
            print(error)
        }
    }
    
    func getAttributedTextFromUserDefault(key: String) -> NSAttributedString? {
        if let data = UserDefaults.standard.data(forKey: key) {
            do {
                if let attributedText = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? NSAttributedString {
                    // Apply custom attributes, such as image width
                    let mutableAttributedText = NSMutableAttributedString(attributedString: attributedText)
                    mutableAttributedText.enumerateAttribute(.attachment, in: NSRange(location: 0, length: mutableAttributedText.length), options: []) { (value, range, stop) in
                        if let attachment = value as? NSTextAttachment,
                           let imageWidth = (attachment as? CustomTextAttachment)?.imageWidths {
                            attachment.bounds.size.width = imageWidth
                        }
                    }
                    return mutableAttributedText
                }
            } catch {
                print(error)
            }
        }
        return nil
    }
}



class CustomTextAttachment: NSTextAttachment {
    var imageWidths: CGFloat = 0.0
}

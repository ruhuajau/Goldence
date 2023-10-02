//
//  EditNoteViewController.swift
//  Goldence
//
//  Created by 趙如華 on 2023/10/2.
//

import UIKit

class EditNoteViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImageEditingDelegate {

    @IBOutlet weak var textView: UITextView!
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        // Add tap gesture recognizer to detect image taps
        // Add a custom UITapGestureRecognizer to the UITextView
        textView.isUserInteractionEnabled = true
        textView.layer.borderWidth = 1.0 // Set the border width
        textView.layer.borderColor = UIColor.black.cgColor // Set the border color
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        textView.addGestureRecognizer(tapGestureRecognizer)

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

    // UIImagePickerControllerDelegate method for handling the selected image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
                    let imageSize = CGSize(width: textView.bounds.width, height: selectedImage.size.height * (textView.bounds.width / selectedImage.size.width))

                    // Create an NSAttributedString with an NSTextAttachment containing the resized image
                    let textAttachment = NSTextAttachment()
                    textAttachment.image = selectedImage
                    textAttachment.bounds = CGRect(origin: .zero, size: imageSize)
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
                    attachment.bounds = CGRect(origin: .zero, size: editedImage.size) // Update bounds if needed

                    // Refresh the textView to display the edited image
                    textView.layoutManager.ensureLayout(for: textView.textContainer)
                    textView.setNeedsDisplay()

                    stop.pointee = true // Stop the enumeration
                }
            }
    }

    @IBAction func saveButtonTapped(_ sender: Any) {
        
    }
    
}

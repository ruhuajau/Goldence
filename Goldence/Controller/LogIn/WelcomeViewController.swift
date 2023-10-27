//
//  WelcomeViewController.swift
//  Goldence
//
//  Created by 趙如華 on 2023/10/5.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {
    
    var userID: String?
    @IBOutlet var nameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(userID)
        // Do any additional setup after loading the view.
        // Set the border color
        nameTextField.layer.borderColor = UIColor.hexStringToUIColor(hex: "6b9080").cgColor // Change to your desired border color
               nameTextField.layer.borderWidth = 1.0 // Set the border width (1.0 points in this example)
               nameTextField.layer.cornerRadius = 5.0 // Set the corner radius (optional, adds rounded corners)
    }

    @IBAction func confirmButtonTapped(_ sender: Any) {
        guard let userID = userID, let newName = nameTextField.text else {
                    // Handle error, one or both of these values is nil
                    return
                }

                let usersCollection = Firestore.firestore().collection("users")
                let userDocRef = usersCollection.document(userID)

                // Update the "name" field for the user
                userDocRef.updateData(["name": newName]) { error in
                    if let error = error {
                        print("Error updating user's name: \(error.localizedDescription)")
                        // Handle the error appropriately
                    } else {
                        print("User's name updated successfully.")
                        // Handle the successful update if needed
                    }
                }
    }
}

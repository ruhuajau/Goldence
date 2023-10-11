//
//  ProfileViewController.swift
//  Goldence
//
//  Created by 趙如華 on 2023/10/10.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    @IBOutlet weak var analysisButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Fetch the user's name from Firebase and set it in the nameLabel
        if let userIdentifier = UserDefaults.standard.string(forKey: "userIdentifier") {
            fetchUserNameFromFirebase(userIdentifier: userIdentifier)
            print("UserIdentifier in UserDefaults")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        editButton.layer.cornerRadius = 8
        editButton.layer.borderColor = UIColor.hexStringToUIColor(hex: "6096ba").cgColor
        editButton.layer.borderWidth = 1
        
        analysisButton.layer.cornerRadius = 8
        analysisButton.layer.borderColor = UIColor.hexStringToUIColor(hex: "6096ba").cgColor
        analysisButton.layer.borderWidth = 1
        // Do any additional setup after loading the view.
        if let navigationBar = navigationController?.navigationBar {
            // Customize the title color
            navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        }
    }
    func fetchUserNameFromFirebase(userIdentifier: String) {
            let usersCollection = Firestore.firestore().collection("users")
            let userDocRef = usersCollection.document(userIdentifier)

            userDocRef.getDocument { [weak self] (document, error) in
                guard let self = self else { return }
                if let document = document, document.exists {
                    if let userData = document.data(),
                       let userName = userData["Name"] as? String {
                        // Update the nameLabel with the fetched user name
                        self.nameLabel.text = userName
                        print(userName)
                    }
                } else {
                    // Handle the case where the user document doesn't exist in Firebase
                    print("User document not found in Firebase.")
                }
            }
        }
}

//
//  ProfileViewController.swift
//  Goldence
//
//  Created by 趙如華 on 2023/10/10.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var analysisButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
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
}

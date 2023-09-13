//
//  ViewController.swift
//  Goldence
//
//  Created by 趙如華 on 2023/9/13.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let articles = Firestore.firestore().collection("articles")
        let document = articles.document()
        let data: [String: Any] = [
            "author": [
                "email": "ab@school.appworks.tw",
                "id": "123",
                "name": "name"
            ],
            "title": "title",
            "category": "category",
            "content": "content",
            "createdTime": Date().timeIntervalSince1970,
            ]

        document.setData(data) { error in
            if let error = error {
                print("Error publishing article: \(error.localizedDescription)")
            } else {
                // Article successfully published
                self.dismiss(animated: true)
            }
        }
    }


}


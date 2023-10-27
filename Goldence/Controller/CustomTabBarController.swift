//
//  CustomTabBarController.swift
//  Goldence
//
//  Created by 趙如華 on 2023/9/26.
//

import UIKit

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        tabBar.tintColor = .black
    }
}

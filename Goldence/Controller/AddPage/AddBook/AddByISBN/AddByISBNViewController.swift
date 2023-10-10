//
//  AddByISBNViewController.swift
//  Goldence
//
//  Created by 趙如華 on 2023/9/14.
//

import UIKit

class AddByISBNViewController: UIViewController {

    var bookshelfID: String?
    @IBOutlet weak var segmentoutlet: UISegmentedControl!
    @IBOutlet weak var typeSegmentView: UIView!
    @IBOutlet weak var scanSegmentView: UIView!
    @IBOutlet weak var bookImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.bringSubviewToFront(typeSegmentView)
        view.backgroundColor = UIColor.hexStringToUIColor(hex: "f8f9fa")
        // Create a custom back button with the image
        let backButtonImage = UIImage(named: "Icons_24px_Back02") // Replace "Icons_24px_Back02" with your image's name
        let customBackButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(customBackAction))
        customBackButton.tintColor = UIColor.hexStringToUIColor(hex: "1f7a8c")

        // Set the custom back button as the left bar button item
        navigationItem.leftBarButtonItem = customBackButton
        if let navigationBar = navigationController?.navigationBar {
            // Customize the title color
            navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        }

    }
    @objc func customBackAction() {

        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func segmentAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            case 0:
                self.view.bringSubviewToFront(typeSegmentView)
            case 1:
                self.view.bringSubviewToFront(scanSegmentView)
            default:
                break
            }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ISBNType" {
            if let destinationVC = segue.destination as? TypeViewController {
                destinationVC.bookshelfID = self.bookshelfID
            }
        }
        if segue.identifier == "ISBNScan" {
            if let destinationVC = segue.destination as? ScanViewController {
                destinationVC.bookshelfID = self.bookshelfID
            }
        }
    }
}

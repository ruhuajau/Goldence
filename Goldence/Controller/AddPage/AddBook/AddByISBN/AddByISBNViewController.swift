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

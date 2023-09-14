//
//  AddByISBNViewController.swift
//  Goldence
//
//  Created by 趙如華 on 2023/9/14.
//

import UIKit

class AddByISBNViewController: UIViewController {

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
}

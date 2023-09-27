//
//  ScheduleViewController.swift
//  Goldence
//
//  Created by 趙如華 on 2023/9/26.
//

import UIKit

class ScheduleViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var segmentOutlet: UISegmentedControl!
    @IBOutlet weak var morningSegmentView: UIView!
    @IBOutlet weak var afternoonSegmentView: UIView!
    @IBOutlet weak var nightSegmentView: UIView!
    let dateFormatter = DateFormatter()
    let currentDate = Date()
    override func viewDidLoad() {
        super.viewDidLoad()

        dateFormatter.dateFormat = "MMM d, yyyy"
        dateLabel.text = dateFormatter.string(from: currentDate)
        self.view.bringSubviewToFront(morningSegmentView)
    }
    @IBAction func segmentAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.view.bringSubviewToFront(morningSegmentView)
        case 1:
            self.view.bringSubviewToFront(afternoonSegmentView)
        case 2:
            self.view.bringSubviewToFront(nightSegmentView)
        default:
            break
        }
    }
    
}

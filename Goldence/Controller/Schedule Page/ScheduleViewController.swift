//
//  ScheduleViewController.swift
//  Goldence
//
//  Created by 趙如華 on 2023/9/26.
//

import UIKit
import Firebase

class ScheduleViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var segmentOutlet: UISegmentedControl!
    @IBOutlet weak var morningSegmentView: UIView!
    @IBOutlet weak var afternoonSegmentView: UIView!
    @IBOutlet weak var nightSegmentView: UIView!
    let dateFormatter = DateFormatter()
        let currentDate = Date()
        var documentID: String = ""
        override func viewDidLoad() {
            super.viewDidLoad()
            dateFormatter.dateFormat = "MMM d, yyyy"
            dateLabel.text = dateFormatter.string(from: currentDate)
            // Generate a document ID for the current date
            self.documentID = generateDocumentID(for: currentDate)
            // Check if a document with the same ID exists and create one if not
            checkAndCreateDocumentIfNeeded(documentID: documentID, currentDate: currentDate)
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
    func generateDocumentID(for date: Date) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd"
            return dateFormatter.string(from: date)
        }
    func checkAndCreateDocumentIfNeeded(documentID: String, currentDate: Date) {
        let db = Firestore.firestore()
        let schedulesRef = db.collection("schedules").document(documentID)

        schedulesRef.getDocument { (document, error) in
            if let error = error {
                print("Error fetching document: \(error.localizedDescription)")
                return
            }

            // Check if the document exists
            if let document = document, document.exists {
                // Document already exists, do nothing
                print("Document already exists.")
            } else {
                // Document doesn't exist, create a new one
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let formattedDate = dateFormatter.string(from: currentDate)

                let data: [String: Any] = [
                    "date": formattedDate,
                    "morning": [], // Initialize the "morning" field with an empty array
                    "afternoon": [], // Add other fields as needed
                    "night": []
                ]

                schedulesRef.setData(data) { error in
                    if let error = error {
                        print("Error creating document: \(error.localizedDescription)")
                    } else {
                        print("Document created successfully!")
                    }
                }
            }
        }
    }

   
}

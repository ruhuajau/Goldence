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

            // Define the font you want to use
                    let font = UIFont(name: "Savoye LET", size: 25) // Replace "YourFontName" with the name of your custom font

                    // Define text attributes
                    let normalTextAttributes = [
                        NSAttributedString.Key.font: font!,
                        NSAttributedString.Key.foregroundColor: UIColor.black                    ]

                    // Apply the text attributes to the normal state
            segmentOutlet.setTitleTextAttributes(normalTextAttributes, for: .normal)

                    // You can also set attributes for the selected state if needed
                    let selectedTextAttributes = [
                        NSAttributedString.Key.font: font!,
                        NSAttributedString.Key.foregroundColor: UIColor.white // Change text color if needed
                    ]
            dateFormatter.dateFormat = "MMM d, yyyy"
            dateLabel.text = dateFormatter.string(from: currentDate)
            // Generate a document ID for the current date
            self.documentID = generateDocumentID(for: currentDate)
            // Check if a document with the same ID exists and create one if not
            checkAndCreateDocumentIfNeeded(documentID: documentID, currentDate: currentDate)
            findFirstNumbersAndScheduleNotification(documentID: documentID)
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
        // Step 1: Retrieve the identifier from UserDefaults
        guard let identifier = UserDefaults.standard.string(forKey: "userIdentifier") else {
            print("Identifier not found in UserDefaults.")
            return
        }

        let db = Firestore.firestore()
        let usersRef = db.collection("users").document(identifier)
        let schedulesRef = usersRef.collection("schedules").document(documentID)

        // Step 2: Check if the schedules document with the specified documentID exists
        schedulesRef.getDocument { (schedulesDocument, schedulesError) in
            if let schedulesError = schedulesError {
                print("Error fetching schedules document: \(schedulesError.localizedDescription)")
                return
            }

            if let schedulesDocument = schedulesDocument, schedulesDocument.exists {
                // Schedules document already exists, do nothing
                print("Schedules document already exists.")
            } else {
                // Schedules document doesn't exist, create a new one
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd"
                let formattedDate = dateFormatter.string(from: currentDate)

                let schedulesData: [String: Any] = [
                    "date": formattedDate,
                    "morning": [],
                    "afternoon": [],
                    "night": []
                ]

                // Step 3: Add schedules data to the user document with the provided documentID
                schedulesRef.setData(schedulesData) { error in
                    if let error = error {
                        print("Error creating schedules document: \(error.localizedDescription)")
                    } else {
                        print("Schedules document created successfully with documentID: \(documentID)")
                    }
                }
            }
        }
    }

    func scheduleNotification(hour: Int) {
        let content = UNMutableNotificationContent()
        content.title = "該來看書囉！"
        //content.subtitle = "子標題"
        content.body = "快打開書，記點筆記吧"
        content.badge = 1

        let dateComponents = DateComponents(hour: hour) // 1
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true) // 2
        let request = UNNotificationRequest(identifier: "Notification", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { err in
            err != nil ? print("添加本地通知錯誤", err!.localizedDescription) : print("添加本地通知成功")
        }

    }
    
    func findFirstNumbersAndScheduleNotification(documentID: String) {
        let db = Firestore.firestore()
        let schedulesRef = db.collection("schedules").document(documentID)

        schedulesRef.addSnapshotListener { (document, error) in
            if let error = error {
                print("Error fetching document: \(error.localizedDescription)")
                return
            }

            // Check if the document exists
            if let document = document, document.exists {
                // Document exists, extract data
                if let data = document.data(),
                   let morning = data["morning"] as? [Int],
                   let afternoon = data["afternoon"] as? [Int],
                   let night = data["night"] as? [Int] {

                    // Get the first number from each array, if available
                    let firstMorningNumber = morning.first
                    let firstAfternoonNumber = afternoon.first
                    let firstNightNumber = night.first

                    // Schedule notifications for the specified hours
                    if let morningNumber = firstMorningNumber {
                        self.scheduleNotification(hour: morningNumber)
                    }
                    if let afternoonNumber = firstAfternoonNumber {
                        self.scheduleNotification(hour: afternoonNumber)
                    }
                    if let nightNumber = firstNightNumber {
                        self.scheduleNotification(hour: nightNumber)
                    }
                }
            } else {
                // Document doesn't exist
                print("Document with ID \(documentID) does not exist.")
            }
        }
    }
}

//
//  AfternoonViewController.swift
//  Goldence
//
//  Created by 趙如華 on 2023/9/26.
//

import UIKit
import Firebase

class AfternoonViewController: UIViewController {
    var orangeSquareNumbers: [Int] = [] // Array to store numbers of orange square
    var documentID: String?
    let currentDate = Date()
    let db = Firestore.firestore()
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editButton.layer.cornerRadius = 8
        saveButton.layer.cornerRadius = 8
        self.documentID = generateDocumentID(for: currentDate)
            let rectangleWidth: CGFloat = 110
            let rectangleHeight: CGFloat = 45
            let numRows = 6
            let numCols = 1
            let padding: CGFloat = 7
            var squareNumber = 12
            for row in 0..<numRows {
                for col in 0..<numCols {
                    let x = CGFloat(col) * (rectangleWidth + padding)
                    let y = CGFloat(row) * (rectangleHeight + padding)
                    let squareFrame = CGRect(x: x + 200, y: y + 50, width: rectangleWidth, height: rectangleHeight)
                    let squareView = SquareView(frame: squareFrame)
                    squareView.squareNumber = squareNumber
                    squareNumber += 1
                    view.addSubview(squareView)
                    squareView.orangeSquareHandler = { [weak self] number, isOrange in
                        if isOrange {
                            self?.orangeSquareNumbers.append(number)
                        } else if let index = self?.orangeSquareNumbers.firstIndex(of: number) {
                            self?.orangeSquareNumbers.remove(at: index)
                        }
                        self?.orangeSquareNumbers.sort()
                        print("Orange squares: \(self?.orangeSquareNumbers ?? [])")
                    }
                }
            }
        // Calculate the width of the time label view based on the square size
        let timeLabelViewWidth = rectangleWidth
        let timeLabelViewFrame = CGRect(x: 200 - timeLabelViewWidth, y: 80, width: timeLabelViewWidth, height: CGFloat(TimeLabelView(frame: .zero, squareSize: rectangleHeight, startHour: 12, endHour: 17).labels.count) * (rectangleHeight + padding))
        let timeLabelView = TimeLabelView(frame: timeLabelViewFrame, squareSize: rectangleHeight, startHour: 12, endHour: 17)
        view.addSubview(timeLabelView)
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchPoint = touch.location(in: view)
            for case let squareView as SquareView in view.subviews {
                if squareView.frame.contains(touchPoint) {
                    squareView.toggleColor()
                } else {
                    squareView.isTouched = false
                }
            }
        }
    }
    func generateDocumentID(for date: Date) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd"
            return dateFormatter.string(from: date)
        }

    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let documentID = documentID, !documentID.isEmpty else {
                print("Invalid or empty documentID.")
                return
            }

            // Step 1: Retrieve the identifier from UserDefaults
            guard let identifier = UserDefaults.standard.string(forKey: "userIdentifier") else {
                print("Identifier not found in UserDefaults.")
                return
            }

            let db = Firestore.firestore()
            let usersRef = db.collection("users").document(identifier)
            let schedulesRef = usersRef.collection("schedules").document(documentID)

            // Step 2: Update the "morning" data in the user's "schedules" document
            schedulesRef.getDocument { (document, error) in
                if let error = error {
                    print("Error fetching document: \(error.localizedDescription)")
                    return
                }

                // Check if the document exists
                if let document = document, document.exists {
                    // Document exists, update it with the new "morning" data
                    var updatedData = document.data() ?? [:]
                    updatedData["afternoon"] = self.orangeSquareNumbers // Add the morning data here

                    // Step 3: Update the document with the modified data
                    schedulesRef.setData(updatedData, merge: true) { error in
                        if let error = error {
                            print("Error updating document: \(error.localizedDescription)")
                        } else {
                            self.showAlert(title: "Success!", message: "Upload successfully!")
                            print("Afternoon data updated successfully!")
                        }
                    }
                } else {
                    print("Document with ID \(documentID) does not exist.")
                }
            }

    }
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
    }

}



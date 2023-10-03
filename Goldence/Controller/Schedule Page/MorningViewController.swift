//
//  MorningViewController.swift
//  Goldence
//
//  Created by 趙如華 on 2023/9/26.
//

import UIKit
import Firebase

class MorningViewController: UIViewController {
    var orangeSquareNumbers: [Int] = [] // Array to store numbers of orange square
    var documentID: String?
    let currentDate = Date()

    let db = Firestore.firestore()
    override func viewDidLoad() {
            super.viewDidLoad()
        self.documentID = generateDocumentID(for: currentDate)
            let rectangleWidth: CGFloat = 70
            let rectangleHeight: CGFloat = 45
            let numRows = 6
            let numCols = 1
            let padding: CGFloat = 7
            var squareNumber = 6
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

            // Calculate the width of the time label view based on the rectangle size
            let timeLabelViewWidth = rectangleWidth
            let timeLabelViewFrame = CGRect(x: 200 - timeLabelViewWidth, y: 80, width: timeLabelViewWidth, height: CGFloat(TimeLabelView(frame: .zero, squareSize: rectangleHeight).labels.count) * (rectangleHeight + padding))
            let timeLabelView = TimeLabelView(frame: timeLabelViewFrame, squareSize: rectangleHeight)
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
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let documentID = documentID, !documentID.isEmpty else {
            print("Invalid or empty documentID.")
            return
        }

            let schedulesRef = db.collection("schedules").document(documentID)

            schedulesRef.getDocument { (document, error) in
                if let error = error {
                    print("Error fetching document: \(error.localizedDescription)")
                    return
                }

                // Check if the document exists
                if let document = document, document.exists {
                    // Document exists, update it with the new "morning" data
                    var updatedData = document.data() ?? [:]
                    updatedData["morning"] = self.orangeSquareNumbers // Add the morning data here

                    // Update the document with the modified data
                    schedulesRef.setData(updatedData, merge: true) { error in
                        if let error = error {
                            print("Error updating document: \(error.localizedDescription)")
                        } else {
                            print("Morning data updated successfully!")
                        }
                    }
                } else {
                    print("Document with ID \(documentID) does not exist.")
                }
            }
        }
    func generateDocumentID(for date: Date) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd"
            return dateFormatter.string(from: date)
        }

    }

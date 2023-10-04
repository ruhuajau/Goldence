//
//  NightViewController.swift
//  Goldence
//
//  Created by 趙如華 on 2023/9/26.
//

import UIKit
import Firebase

class TimeLabelView3: UIView {
    let labels = ["18:00", "19:00", "20:00", "21:00", "22:00", "23:00"]
    let squareSize: CGFloat
    init(frame: CGRect, squareSize: CGFloat) {
        self.squareSize = squareSize
        super.init(frame: frame)
        setupLabels()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupLabels() {
        let labelHeight: CGFloat = 20
        let spacing: CGFloat = 7
        for (index, labelText) in labels.enumerated() {
            let labelFrame = CGRect(x: -20, y: CGFloat(index) * (squareSize + spacing) - 25, width: squareSize + 5, height: labelHeight)
            let label = UILabel(frame: labelFrame)
            label.text = labelText
            label.textAlignment = .right
            addSubview(label)
        }
    }
}

class NightViewController: UIViewController {
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
            let rectangleWidth: CGFloat = 70
            let rectangleHeight: CGFloat = 45
            let numRows = 6
            let numCols = 1
            let padding: CGFloat = 7
            var squareNumber = 18
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
        let timeLabelViewFrame = CGRect(x: 200 - timeLabelViewWidth, y: 80, width: timeLabelViewWidth, height: CGFloat(TimeLabelView3(frame: .zero, squareSize: rectangleHeight).labels.count) * (rectangleHeight + padding))
        let timeLabelView = TimeLabelView3(frame: timeLabelViewFrame, squareSize: rectangleHeight)
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
                    updatedData["night"] = self.orangeSquareNumbers // Add the morning data here

                    // Update the document with the modified data
                    schedulesRef.setData(updatedData, merge: true) { error in
                        if let error = error {
                            print("Error updating document: \(error.localizedDescription)")
                        } else {
                            print("Morning data updated successfully!")
                        }
                    }
                } else {
                    self.showAlert(title: "成功", message: "已順利加入！")
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

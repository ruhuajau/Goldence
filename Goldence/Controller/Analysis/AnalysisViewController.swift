//
//  AnalysisViewController.swift
//  Goldence
//
//  Created by 趙如華 on 2023/10/3.
//

import UIKit
import Charts
import Firebase

class AnalysisViewController: UIViewController {

    @IBOutlet weak var lineChartView: LineChartView!
    var chartData: [ChartDataEntry] = []
        var dates: [String] = []

        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = UIColor.hexStringToUIColor(hex: "f8f9fa")
            // Create a custom back button with the image
            let backButtonImage = UIImage(named: "Icons_24px_Back02") // Replace "Icons_24px_Back02" with your image's name
            let customBackButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(customBackAction))
            customBackButton.tintColor = UIColor.hexStringToUIColor(hex: "1f7a8c")

            fetchDataForLineChart()
            lineChartView.extraTopOffset = 50 // Add extra top offset (adjust as needed)
            lineChartView.extraBottomOffset = 50 // Add extra bottom offset (adjust as needed)
        }
    
    func fetchDataForLineChart() {
        let db = Firestore.firestore()
        let collectionRef = db.collection("schedules")

        var dateCountMap: [String: Int] = [:]

        // Query the most recent three documents from the "schedules" collection
        collectionRef.order(by: "date", descending: true).limit(to: 3).addSnapshotListener { [weak self] (querySnapshot, error) in
            guard let self = self, error == nil else {
                print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            dateCountMap.removeAll()
            // Iterate through each document
            for document in querySnapshot?.documents ?? [] {
                if let data = document.data() as? [String: Any],
                   let date = data["date"] as? String,
                   let morning = data["morning"] as? [Int],
                   let afternoon = data["afternoon"] as? [Int],
                   let night = data["night"] as? [Int] {
                    // Calculate the total counts of data for each date and add them to dateCountMap
                    let total = morning.count + afternoon.count + night.count
                    dateCountMap[date] = (dateCountMap[date] ?? 0) + total
                }
            }

            // Extract the dates and counts from the dateCountMap
            let sortedDates = Array(dateCountMap.keys).sorted()
            self.chartData = sortedDates.enumerated().map { index, date in
                ChartDataEntry(x: Double(index), y: Double(dateCountMap[date] ?? 0))
            }
            // Convert dates to abbreviated format and set up the line chart
            self.dates = self.abbreviateDates(sortedDates)
            print(self.dates)
            self.setupLineChart()
        }
    }


    func setupLineChart() {
        let line1 = LineChartDataSet(entries: chartData, label: "Total Counts")
        let color = NSUIColor(cgColor: UIColor.hexStringToUIColor(hex: "6096ba").cgColor)
        line1.colors = [color]
        line1.circleRadius = 0
        line1.mode = .horizontalBezier
        
        let data = LineChartData(dataSet: line1)
        lineChartView.data = data

        lineChartView.chartDescription.text = "Total Counts by Date"
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: abbreviateDates(dates))
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.xAxis.drawAxisLineEnabled = true
        lineChartView.leftAxis.drawGridLinesEnabled = false
        lineChartView.rightAxis.drawGridLinesEnabled = false
        lineChartView.data?.setValueTextColor(.clear)

        print(dates)
        lineChartView.xAxis.labelRotationAngle = 0
        lineChartView.xAxis.granularity = 1

    }
    
    func abbreviateDates(_ dates: [String]) -> [String] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        return dates.map { dateStr in
            if let date = dateFormatter.date(from: dateStr) {
                dateFormatter.dateFormat = "MM/dd"
                return dateFormatter.string(from: date)
            }
            return dateStr
        }
    }
    @objc func customBackAction() {

        self.navigationController?.popViewController(animated: true)
    }

}

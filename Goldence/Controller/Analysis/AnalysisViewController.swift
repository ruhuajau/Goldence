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

            fetchDataForLineChart()
        }

    func fetchDataForLineChart() {
        let db = Firestore.firestore()
        let collectionRef = db.collection("schedules")

        var dateCountMap: [String: Int] = [:]

        // Query the first three documents from the "schedules" collection
        collectionRef.limit(to: 3).addSnapshotListener { [weak self] (querySnapshot, error) in
            guard let self = self, error == nil else {
                print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            for document in querySnapshot?.documents ?? [] {
                if let data = document.data() as? [String: Any],
                   let date = data["date"] as? String,
                   let morning = data["morning"] as? [Int],
                   let afternoon = data["afternoon"] as? [Int],
                   let night = data["night"] as? [Int] {
                    // Calculate the total counts of data for each date and sum them up
                    let total = morning.count + afternoon.count + night.count
                    dateCountMap[date] = (dateCountMap[date] ?? 0) + total
                }
            }

            // Extract the dates and counts from the dateCountMap
            self.dates = Array(dateCountMap.keys)
            self.chartData = self.dates.map { date in
                ChartDataEntry(x: Double(self.dates.firstIndex(of: date) ?? 0), y: Double(dateCountMap[date] ?? 0))
            }

            // Call the method to set up and display the line chart
            self.setupLineChart()
        }
    }


        func setupLineChart() {
            var lineChartEntry = [ChartDataEntry]()
            for i in 0..<chartData.count {
                let value = chartData[i]
                lineChartEntry.append(value)
            }

            let line1 = LineChartDataSet(entries: lineChartEntry, label: "Total Counts")
            line1.colors = [NSUIColor.blue]

            let data = LineChartData(dataSet: line1)
            lineChartView.data = data

            lineChartView.chartDescription.text = "Total Counts by Date"
            lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dates)
            lineChartView.xAxis.labelRotationAngle = -45
        }
}

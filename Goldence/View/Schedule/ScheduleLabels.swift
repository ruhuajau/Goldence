//
//  ScheduleLabels.swift
//  Goldence
//
//  Created by 趙如華 on 2023/10/3.
//

import Foundation
import UIKit

class TimeLabelView: UIView {
    let squareSize: CGFloat
    var labels: [String] = []

    init(frame: CGRect, squareSize: CGFloat, startHour: Int, endHour: Int) {
        self.squareSize = squareSize
        super.init(frame: frame)
        generateLabels(startHour: startHour, endHour: endHour)
        setupLabels()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func generateLabels(startHour: Int, endHour: Int) {
        for hour in startHour...endHour {
            let time = hour < 10 ? "0\(hour):00" : "\(hour):00"
            labels.append(time)
        }
    }
    
    func generateLabelsString(startHour: Int, endHour: Int) -> [String] {
        var labels: [String] = []
        for hour in startHour...endHour {
            let time = hour < 10 ? "0\(hour):00" : "\(hour):00"
            labels.append(time)
        }
        return labels
    }


    private func setupLabels() {
        let labelHeight: CGFloat = 20
        let spacing: CGFloat = 7

        for (index, labelText) in labels.enumerated() {
            let labelFrame = CGRect(x: 15, y: CGFloat(index) * (squareSize + spacing) - 25, width: squareSize + 15, height: labelHeight)
            let label = UILabel(frame: labelFrame)
            label.text = labelText
            label.textColor = UIColor.black
            label.font = UIFont(name: "Savoye LET", size: 30)
            label.textAlignment = .right
            addSubview(label)
        }
    }
}


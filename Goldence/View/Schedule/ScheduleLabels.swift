//
//  ScheduleLabels.swift
//  Goldence
//
//  Created by 趙如華 on 2023/10/3.
//

import Foundation
import UIKit

class TimeLabelView: UIView {
    var labels = [String]()
    let squareSize: CGFloat
    init(frame: CGRect, squareSize: CGFloat, labels: [String]) {
        self.labels = labels
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

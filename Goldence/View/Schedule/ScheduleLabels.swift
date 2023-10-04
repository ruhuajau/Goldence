//
//  ScheduleLabels.swift
//  Goldence
//
//  Created by 趙如華 on 2023/10/3.
//

import Foundation
import UIKit

class TimeLabelView: UIView {
    let labels = ["6:00", "7:00", "8:00", "9:00", "10:00", "11:00"]
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

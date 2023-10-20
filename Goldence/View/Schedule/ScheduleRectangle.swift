//
//  ScheduleRectangle.swift
//  Goldence
//
//  Created by 趙如華 on 2023/10/3.
//

import Foundation
import UIKit

class SquareView: UIView {
    var isOrange = false {
        didSet {
            updateColor()
        }
    }
    var isTouched = false
    var squareNumber: Int = 0
    var orangeSquareHandler: ((Int, Bool) -> Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    // Add properties for square size and layout
    static let rectangleWidth: CGFloat = 110
    static let rectangleHeight: CGFloat = 45
    static let padding: CGFloat = 7

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setup() {
        backgroundColor = .white
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = 10
    }
    func toggleColor() {
        if !isTouched {
            isOrange.toggle()
            isTouched = true
        }
    }
    private func updateColor() {
        backgroundColor = isOrange ? UIColor.hexStringToUIColor(hex: "6b9080") : .white
        orangeSquareHandler?(squareNumber, isOrange)
        if isOrange {
            print("Square \(squareNumber) turned orange")
        }
    }
}

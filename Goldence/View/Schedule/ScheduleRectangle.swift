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
            backgroundColor = isOrange ? UIColor.hexStringToUIColor(hex: "6b9080") : .white
            orangeSquareHandler?(squareNumber, isOrange)
            if isOrange {
                print("Square \(squareNumber) turned orange")
            }
        }
    }
    var isTouched = false
    var squareNumber: Int = 0
    var orangeSquareHandler: ((Int, Bool) -> Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
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
}

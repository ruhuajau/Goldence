//
//  MorningViewController.swift
//  Goldence
//
//  Created by 趙如華 on 2023/9/26.
//

import UIKit

class SquareView: UIView {
    var isOrange = false {
        didSet {
            backgroundColor = isOrange ? .orange : .white
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
    }
    func toggleColor() {
        if !isTouched {
            isOrange.toggle()
            isTouched = true
        }
    }
}

class MorningViewController: UIViewController {
    let scrollView = UIScrollView()
    var orangeSquareNumbers: [Int] = [] // Array to store numbers of orange squares
    override func viewDidLoad() {
        super.viewDidLoad()
        let squareSize: CGFloat = 45
        let numRows = 6
        let numCols = 2
        let padding: CGFloat = 7
        var squareNumber = 1
        for row in 0..<numRows {
            for col in 0..<numCols {
                let x = CGFloat(col) * (squareSize + padding)
                let y = CGFloat(row) * (squareSize + padding)
                let squareFrame = CGRect(x: x + 200, y: y + 80, width: squareSize, height: squareSize)
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
}

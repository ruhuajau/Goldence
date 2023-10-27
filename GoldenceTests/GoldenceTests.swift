//
//  GoldenceTests.swift
//  GoldenceTests
//
//  Created by 趙如華 on 2023/10/22.
//

import XCTest
@testable import Goldence

final class GoldenceTests: XCTestCase {

    func testGenerateLabels() {
        // Create an instance of TimeLabelView
        let timeLabelView = TimeLabelView(frame: .zero, squareSize: 40, startHour: 8, endHour: 12)
        // Call the function to be tested
        timeLabelView.generateLabelsString(startHour: 8, endHour: 12)
        // Assert that the labels property contains the expected values
        XCTAssertEqual(timeLabelView.labels, ["08:00", "09:00", "10:00", "11:00", "12:00"])
    }
    func testCalculateHeight() {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 100)) // Adjust these values as needed
        guard let selectedImage = UIImage(named: "titleView") else { return } // Provide a test image
        let calculatedRect = ImageViewController.calculateHeight(containerView: containerView, selectedImage: selectedImage)
        // Assert against the expected output
        XCTAssertEqual(calculatedRect.origin.x, 0.0, accuracy: 0.001)
        XCTAssertEqual(calculatedRect.height, selectedImage.size.height/selectedImage.size.width * 200, accuracy: 0.001)
        XCTAssertEqual(calculatedRect.size.width, containerView.frame.size.width, accuracy: 0.001)
    }
    func testToggleColor() {
        // Create a test instance of SquareView
        let squareView = SquareView(frame: CGRect(x: 0, y: 0, width: 100, height: 100)) // Adjust frame as needed
        // Call the function to be tested
        squareView.toggleColor()
        // Assert that the isOrange property has toggled
        XCTAssertTrue(squareView.isOrange)
    }

}

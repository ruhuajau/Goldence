//
//  ScanButton.swift
//  Goldence
//
//  Created by 趙如華 on 2023/9/25.
//

import Foundation
import UIKit

class ScanButton: UIButton{
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
        
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
        
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        setTitle("Scan", for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
        titleLabel?.textColor = .white
        layer.cornerRadius = 7.0
        backgroundColor = UIColor.systemIndigo
    }
}

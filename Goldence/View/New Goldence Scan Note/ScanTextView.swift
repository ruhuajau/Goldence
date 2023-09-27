//
//  ScanTextView.swift
//  Goldence
//
//  Created by 趙如華 on 2023/9/25.
//

import Foundation
import UIKit

class ScanTextView: UITextView{
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: .zero, textContainer: textContainer)
            
        configure()
    }
        
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
        
    private func configure() {
        self.isEditable = true
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 7.0
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.systemTeal.cgColor
        font = .systemFont(ofSize: 16.0)
    }
}

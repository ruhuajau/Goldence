//
//  HomePageTableViewCell.swift
//  Goldence
//
//  Created by 趙如華 on 2023/9/22.
//

import UIKit

class HomePageTableViewCell: UITableViewCell {

    @IBOutlet weak var bookshelfImage: UIImageView!
    @IBOutlet weak var bookshelfTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.backgroundColor = UIColor.hexStringToUIColor(hex: "eaf4f4")
        // Create a rounded mask with a slight curve for the upper two corners
              let cornerRadius: CGFloat = 10.0 // Adjust the value to control the curve
              let maskPath = UIBezierPath(
                  roundedRect: bookshelfImage.bounds,
                  byRoundingCorners: [.topLeft, .topRight, .bottomLeft, .bottomRight],
                  cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
              )
              let maskLayer = CAShapeLayer()
              maskLayer.path = maskPath.cgPath
              bookshelfImage.layer.mask = maskLayer
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

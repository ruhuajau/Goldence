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
    @IBOutlet weak var viewInCell: UIView!
    @IBOutlet weak var shadowLayer: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        bookshelfImage.layer.cornerRadius = 15
        //viewInCell.layer.borderWidth = 1.0
        viewInCell.backgroundColor = UIColor.hexStringToUIColor(hex: "EAF4F4")
        viewInCell.layer.cornerRadius = 15
        viewInCell.layer.masksToBounds = true
        
        shadowLayer.layer.masksToBounds = false

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

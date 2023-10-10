//
//  AddPageTableViewCell.swift
//  Goldence
//
//  Created by 趙如華 on 2023/9/14.
//

import UIKit

class SelectShelfTableViewCell: UITableViewCell {
    @IBOutlet weak var bookShelfImage: UIImageView!
    @IBOutlet weak var bookShelfName: UILabel!
    @IBOutlet weak var shadowLayerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bookShelfImage.layer.cornerRadius = 15
        shadowLayerView.layer.cornerRadius = 15
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

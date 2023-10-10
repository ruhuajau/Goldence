//
//  AddNewCardTableViewCell.swift
//  Goldence
//
//  Created by 趙如華 on 2023/10/10.
//

import UIKit

class AddNewCardTableViewCell: UITableViewCell {

    @IBOutlet weak var addCardImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // Configure the image view with rounded corners
        addCardImage.layer.cornerRadius = addCardImage.frame.size.width / 2
        addCardImage.clipsToBounds = true
        addCardImage.layer.masksToBounds = true

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func layoutSubviews() {
    }

}

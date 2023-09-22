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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

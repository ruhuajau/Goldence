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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

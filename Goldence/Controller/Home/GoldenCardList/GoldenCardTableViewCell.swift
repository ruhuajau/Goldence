//
//  GoldenCardTableViewCell.swift
//  Goldence
//
//  Created by 趙如華 on 2023/9/24.
//

import UIKit

class GoldenCardTableViewCell: UITableViewCell {

    @IBOutlet weak var goldenceImage: UIImageView!
    
    @IBOutlet weak var goldenceTitle: UILabel!    
    @IBOutlet weak var goldenceContent: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

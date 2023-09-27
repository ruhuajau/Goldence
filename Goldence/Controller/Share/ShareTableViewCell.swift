//
//  ShareTableViewCell.swift
//  Goldence
//
//  Created by 趙如華 on 2023/9/26.
//

import UIKit

class ShareTableViewCell: UITableViewCell {
    
    @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var shareTitle: UILabel!
    @IBOutlet weak var shareTextView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

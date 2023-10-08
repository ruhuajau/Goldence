//
//  BookListTableViewCell.swift
//  Goldence
//
//  Created by 趙如華 on 2023/9/22.
//

import UIKit

class BookListTableViewCell: UITableViewCell {

    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var bookView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bookView.layer.masksToBounds = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

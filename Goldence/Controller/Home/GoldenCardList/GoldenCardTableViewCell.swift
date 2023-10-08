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
    @IBOutlet weak var shareButton: UIButton!
    var noteId: String?
    weak var delegate: GoldenCardTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        shareButton.layer.cornerRadius = 15
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func shareButtonTapped(_ sender: Any) {
        delegate?.shareButtonTapped(noteId: noteId ?? "")
    }
}

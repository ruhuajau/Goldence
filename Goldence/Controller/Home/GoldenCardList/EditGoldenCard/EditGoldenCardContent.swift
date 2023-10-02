//
//  EditGoldenCardContent.swift
//  Goldence
//
//  Created by 趙如華 on 2023/10/2.
//

import UIKit

class EditGoldenCardContent: UIViewController {
    
    var noteId: String?
    override func viewDidLoad() {
        super.viewDidLoad()
            }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditGoldenceNote" {
            if let destinationVC = segue.destination as? EditNoteViewController {
                destinationVC.noteId = noteId
            }
        }
    }
}

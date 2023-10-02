//
//  Protocol.swift
//  Goldence
//
//  Created by 趙如華 on 2023/9/21.
//

import Foundation
import UIKit

protocol BookResultViewControllerDelegate: class {
    func didDismissBookResultViewController()
}

protocol GoldenCardTableViewCellDelegate: AnyObject {
    func shareButtonTapped(noteId: String)
}

protocol ImageEditingDelegate: AnyObject {
    func imageEditingViewController(_ controller: ImageViewController, didFinishEditingImage editedImage: UIImage)
}



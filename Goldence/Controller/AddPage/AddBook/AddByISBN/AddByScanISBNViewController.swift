//
//  AddByScanISBNViewController.swift
//  Goldence
//
//  Created by 趙如華 on 2023/9/21.
//
import UIKit

class BookResultViewController: UIViewController {
    var barcodeNumber: String?
    // Properties for UI elements
        let bookCoverImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit // Adjust content mode as needed
            imageView.layer.borderColor = UIColor.black.cgColor
            return imageView
        }()
        let titleLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont.boldSystemFont(ofSize: 20)
            label.textColor = UIColor.black
            label.textAlignment = .center
            label.layer.borderColor = UIColor.black.cgColor
            label.text = "title"
            return label
        }()
        let authorLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont.systemFont(ofSize: 16) // Adjust font size as needed
            label.textColor = UIColor.gray // Adjust text color as needed
            label.textAlignment = .center
            label.text = "author"
            return label
        }()
        override func viewDidLoad() {
            view.backgroundColor = .white
            // Add the titleLabel to the view
            print(barcodeNumber as Any)
            // Create a vertical stack view
                let stackView = UIStackView(arrangedSubviews: [bookCoverImageView, titleLabel, authorLabel])
                stackView.axis = .vertical
                stackView.spacing = 40
                stackView.translatesAutoresizingMaskIntoConstraints = false
                // Add the stack view to the view
                view.addSubview(stackView)
                // Set constraints for the stack view (adjust these constraints as needed)
            // Set constraints for the stack view (adjust these constraints as needed)
            let centerXConstraint = stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            let centerYConstraint = stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            let leadingConstraint = stackView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20)
            let trailingConstraint = stackView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20)

            // Activate the constraints
            NSLayoutConstraint.activate([
                centerXConstraint,
                centerYConstraint,
                leadingConstraint,
                trailingConstraint
            ])

        }
}

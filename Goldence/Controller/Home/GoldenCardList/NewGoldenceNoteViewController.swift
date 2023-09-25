//
//  NewGoldenceNoteViewController.swift
//  Goldence
//
//  Created by 趙如華 on 2023/9/25.
//

import UIKit
import VisionKit

class NewGoldenceNoteViewController: UIViewController {
    
    private var scanButton = ScanButton(frame: .zero)
    private var scanImageView = ScanImageView(frame: .zero)
    private var scanTextView = ScanTextView(frame: .zero, textContainer: nil)
    private var scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    private func configure() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scanTextView)
        view.addSubview(scanButton)
        
        let padding: CGFloat = 16
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            scrollView.bottomAnchor.constraint(equalTo: scanTextView.topAnchor, constant: -padding),
            
            scanButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            scanButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            scanButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            scanButton.heightAnchor.constraint(equalToConstant: 50),
            scanTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            scanTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            scanTextView.bottomAnchor.constraint(equalTo: scanButton.topAnchor, constant: -padding),
            scanTextView.heightAnchor.constraint(equalToConstant: 200)
        ])
        scanButton.addTarget(self, action: #selector(scanDocument), for: .touchUpInside)
    }
    @objc private func scanDocument() {
        let scanVC = VNDocumentCameraViewController()
        scanVC.delegate = self
        present(scanVC, animated: true)
    }
}

extension NewGoldenceNoteViewController
: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        guard scan.pageCount >= 1 else {
            controller.dismiss(animated: true)
            return
        }
        
        for pageIndex in 0..<scan.pageCount {
            let scannedImage = scan.imageOfPage(at: pageIndex)
            let imageView = UIImageView(image: scannedImage)
            imageView.contentMode = .scaleAspectFit
            
            // Calculate the position of the imageView within the scrollView vertically
            let yPosition = CGFloat(pageIndex) * scrollView.bounds.size.height
            imageView.frame = CGRect(x: 0, y: yPosition, width: scrollView.bounds.size.width, height: scrollView.bounds.size.height)
            
            scrollView.addSubview(imageView)
        }

        // Update the content size of the scrollView to allow vertical scrolling
        scrollView.contentSize = CGSize(width: scrollView.bounds.size.width, height: CGFloat(scan.pageCount) * scrollView.bounds.size.height)

        
        controller.dismiss(animated: true)
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        // Handle error
        controller.dismiss(animated: true)
    }
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true)
    }
}

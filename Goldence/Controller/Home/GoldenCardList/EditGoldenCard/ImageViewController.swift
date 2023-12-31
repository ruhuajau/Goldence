//
//  ImageViewController.swift
//  Goldence
//
//  Created by 趙如華 on 2023/10/31.
//

import UIKit
import PencilKit

class ImageViewController: UIViewController, PKCanvasViewDelegate {
    
    @IBOutlet weak var enlargedImageView: UIImageView!
    @IBOutlet weak var drawButton: UIButton!
    var selectedImage: UIImage?
    var canvasView: PKCanvasView?
    weak var delegate: ImageEditingDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let image = selectedImage {
            enlargedImageView.image = image
        }

    }
    func setSize() -> CGRect {
    let containerRatio = self.enlargedImageView.frame.size.height/self.enlargedImageView.frame.size.width
    let imageRatio = self.selectedImage!.size.height/self.selectedImage!.size.width
    if containerRatio > imageRatio {
    return self.getHeight()
    } else {
    return self.getWidth()
    }
    }
    
    private func getHeight() -> CGRect {
    let containerView = self.enlargedImageView!
    let image = self.selectedImage!
    let ratio = containerView.frame.size.width / image.size.width
    let newHeight = ratio * image.size.height
    let size = CGSize(width: containerView.frame.width, height: newHeight)
    var yPosition = (containerView.frame.size.height - newHeight) / 2
    yPosition = (yPosition < 0 ? 0 : yPosition) + containerView.frame.origin.y
    let origin = CGPoint.init(x: containerView.frame.origin.x, y: yPosition)
    return CGRect.init(origin: origin, size: size)
    }
    
    static func calculateHeight(containerView: UIView, selectedImage: UIImage) -> CGRect {
        let ratio = containerView.frame.size.width / selectedImage.size.width
        let newHeight = ratio * selectedImage.size.height
        let size = CGSize(width: containerView.frame.width, height: newHeight)
        var yPosition = (containerView.frame.size.height - newHeight) / 2
        yPosition = (yPosition < 0 ? 0 : yPosition) + containerView.frame.origin.y
        let origin = CGPoint(x: containerView.frame.origin.x, y: yPosition)
        return CGRect(origin: origin, size: size)
    }


    func getWidth() -> CGRect {
    let containerView = self.enlargedImageView!
    let image = self.selectedImage!
    let ratio = containerView.frame.size.height / image.size.height
    let newWidth = ratio * image.size.width
    let size = CGSize(width: newWidth, height: containerView.frame.height)
        var xPosition = ((containerView.frame.size.width - newWidth) / 2) + containerView.frame.origin.x
        xPosition = (xPosition < 0 ? 0 : xPosition) + containerView.frame.origin.x
    let yPosition = containerView.frame.origin.y
    let origin = CGPoint.init(x: xPosition, y: yPosition)
    return CGRect.init(origin: origin, size: size)
    }
    @IBAction func drawButtonTapped(_ sender: Any) {
        // Create a PKCanvasView and overlay it on the UIImageView
                canvasView = PKCanvasView(frame: enlargedImageView.bounds)
                canvasView?.backgroundColor = .clear
                canvasView?.isOpaque = false

                if let canvasView = canvasView {
                    self.view.addSubview(canvasView)
                    canvasView.frame = self.setSize()
                    canvasView.delegate = self
                    // Enable the drawing view
                    canvasView.isUserInteractionEnabled = true
                    canvasView.drawingPolicy = .default

                    self.canvasView?.drawing = PKDrawing()
                    if let window = self.view.window, let toolPicker = PKToolPicker.shared(for: window) {

                        toolPicker.setVisible(true, forFirstResponder: canvasView)
                        toolPicker.addObserver(canvasView)
                        canvasView.becomeFirstResponder()
                    }
                }

        
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        let bottomImage = self.selectedImage!
        let newImage = autoreleasepool { () -> UIImage in
            UIGraphicsBeginImageContextWithOptions(self.canvasView?.frame.size ?? CGSize.zero, false, 0.0)
        bottomImage.draw(in: CGRect(origin: CGPoint.zero, size: self.canvasView!.frame.size))
            var drawing = self.canvasView?.drawing.image(from: self.canvasView!.bounds, scale: 0)
            drawing?.draw(in: CGRect(origin: CGPoint.zero, size: self.canvasView!.frame.size))
        let createdImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.delegate?.imageEditingViewController(self, didFinishEditingImage: createdImage!)
            return createdImage!
        }
        dismiss(animated: true, completion: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Resign the canvas view as the first responder to hide the drawing tools
        canvasView?.resignFirstResponder()
    }

}

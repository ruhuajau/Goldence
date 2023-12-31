//
//  ScanViewController.swift
//  Goldence
//
//  Created by 趙如華 on 2023/9/14.
//

import UIKit
import AVFoundation

class ScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, BookResultViewControllerDelegate {
    var bookshelfID: String?
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var barView: UIView!
    var isScanning = true
    var captureSession: AVCaptureSession?
    var inputLayer: AVCaptureVideoPreviewLayer?
    var barCodeFrameView: UIView?
    override func viewDidLoad() {
        super.viewDidLoad()
        print(bookshelfID)
        // try to find back camera
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .back)
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("Camera device was not found")
            return
        }
        setUpVideoCapture(captureDevice: captureDevice)
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession?.startRunning()
        }
        view.bringSubviewToFront(textLabel)
        // setting frame view on barcode
        barCodeFrameView = UIView()
        if let barcodeFrameView = barCodeFrameView {
            barcodeFrameView.layer.borderColor = UIColor.blue.cgColor
            barcodeFrameView.layer.borderWidth = 1
            view.addSubview(barcodeFrameView)
            view.bringSubviewToFront(barcodeFrameView)
        }
    }
    func setUpVideoCapture(captureDevice: AVCaptureDevice) {
        do {
            let cameraInput = try AVCaptureDeviceInput(device: captureDevice)
            captureSession = AVCaptureSession()
            captureSession?.addInput(cameraInput)
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession!.addOutput(captureMetadataOutput)
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            // setting the type of metadata we are trying to read
            // ISBN barcodes are of type ean13
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.ean13]
            inputLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            inputLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            inputLayer?.frame = barView.layer.bounds
            barView.layer.addSublayer(inputLayer!)
        } catch {
            print(error)
        }
    }
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if isScanning {
            isScanning = false // Stop scanning after the first code is detected
            if metadataObjects.count == 0 {
                barCodeFrameView?.frame = CGRect.zero
                textLabel.text = "No barcode is found"
            } else {
                // found some code
                let metadataObj = metadataObjects[0] as? AVMetadataMachineReadableCodeObject
                if metadataObj?.type == AVMetadataObject.ObjectType.ean13 {
                    // found ISBN barcode
                    let barCodeObject = inputLayer?.transformedMetadataObject(for: metadataObj!)
                    barCodeFrameView?.frame = barCodeObject!.bounds
                    if metadataObj?.stringValue != nil {
                        let barcodeNumber = metadataObj?.stringValue
                        // Assuming you have an instance of BookResultViewController
                        let bookResultViewController = BookResultViewController()
                        bookResultViewController.bookshelfID = self.bookshelfID
                        bookResultViewController.delegate = self
                        bookResultViewController.barcodeNumber = barcodeNumber
                        DispatchQueue.main.async { // Ensure UI updates on the main thread
                            bookResultViewController.modalPresentationStyle = .fullScreen
                            self.present(bookResultViewController, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    func didDismissBookResultViewController() {
        isScanning = true
    }
}

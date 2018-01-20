//
//  ViewController.swift
//  QRCodeReading
//
//  Created by Ádám Bella on 1/20/18.
//  Copyright © 2018 Ádám Bella. All rights reserved.
//

import UIKit
import AVFoundation

extension ViewController : AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {

        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.isEmpty {
            qrCodeFrameView.frame = CGRect.zero
            return
        }
        
        // Get the metadata object.
        guard let metadataObj = metadataObjects.first as? AVMetadataMachineReadableCodeObject else {return}
        
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            guard let barCodeObject = videoPreviewLayer.transformedMetadataObject(for: metadataObj) else {return}
            
            qrCodeFrameView.frame = barCodeObject.bounds
            guard let qrCodeContent = metadataObj.stringValue else {return}
            
            print("Found QR code: \(qrCodeContent)")
        }
    }
    
    fileprivate final func initializeQRCodeReader(){
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video as the media type parameter.
        
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {return}
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Set the input device on the capture session.
            captureSession.addInput(input)
            
            // Set it as the output device to the capture session.
            captureSession.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
        } catch {
            print("Error")
            return
        }
    }
}


class ViewController: UIViewController {
    fileprivate let captureSession = AVCaptureSession()
    fileprivate lazy var videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    fileprivate let qrCodeFrameView = UIView()
    fileprivate let captureMetadataOutput = AVCaptureMetadataOutput()
    
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeVideoPreviewLayer()
        initializeQRCodeHighlightedFrame()
        initializeQRCodeReader()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        qrCodeFrameView.frame = CGRect.zero
        captureSession.startRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        captureSession.stopRunning()
    }

    
    //MARK: - Initialize QR Code Frame to highlight the QR code
    fileprivate final func initializeQRCodeHighlightedFrame(){
        qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
        qrCodeFrameView.layer.borderWidth = 2
        view.addSubview(qrCodeFrameView)
        view.bringSubview(toFront: qrCodeFrameView)
    }
    
    //MARK: - Add it as a sublayer to the viewPreview view's layer.
    fileprivate final func initializeVideoPreviewLayer(){
        videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer)
    }
}


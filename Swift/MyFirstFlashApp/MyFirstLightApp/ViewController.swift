//
//  ViewController.swift
//  MyFirstLightApp
//
//  Created by Ádám Bella on 1/19/18.
//  Copyright © 2018 Ádám Bella. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var lightControlButton: UIButton!
    
    fileprivate let device = AVCaptureDevice.default(for: AVMediaType.video)
    
    fileprivate var isLight = false {
        willSet {
            print("\(newValue)")
        }
        didSet {
            print("new value: \(isLight), old value: \(oldValue)")
            updateUserInterface()
            useFlash()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUserInterface()
    }
    
    func updateUserInterface(){
        if isLight {
            lightControlButton.setTitle("Turn off", for: UIControlState())
            view.backgroundColor = .white
        }else{
            lightControlButton.setTitle("Turn on", for: UIControlState())
            view.backgroundColor = .black
        }
    }

    @IBAction func actionControlLightState(_ sender: Any) {
        isLight = !isLight
    }
    
    //Turn on/off flash
    
    func useFlash(){
        //AVFoundation contains the flash,camera and etc implementations. You have to import it begin of the file
        guard let sDevice = device , sDevice.hasTorch else { return }
            do {
                try sDevice.lockForConfiguration()

                if sDevice.isTorchModeSupported(.on) && sDevice.isTorchModeSupported(.off) {
                    if (sDevice.torchMode == .on) {
                        sDevice.torchMode = .off
                    } else {
                        try sDevice.setTorchModeOn(level: AVCaptureDevice.maxAvailableTorchLevel)
                    }
                }
                sDevice.unlockForConfiguration()
            } catch {
                print("\(error)")
            }
    }
}


//
//  ViewController.swift
//  SpeechRecognitionExample
//
//  Created by Ádám Bella on 1/31/18.
//  Copyright © 2018 Ádám Bella. All rights reserved.
//

import UIKit
import Speech

extension ViewController : SFSpeechRecognitionTaskDelegate {
    public func speechRecognitionTask(_ task: SFSpeechRecognitionTask, didHypothesizeTranscription transcription: SFTranscription) {
        detectedTexts.text = transcription.formattedString
        startNoAudioDurationTimer()
    }
}

class ViewController: UIViewController {
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var detectedTexts: UILabel!
    @IBOutlet weak var recordingStateLabel: UILabel!
    
    fileprivate let audioEngine = AVAudioEngine()
    fileprivate let speechRecognizer : SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    fileprivate var request = SFSpeechAudioBufferRecognitionRequest()
    fileprivate var recognitionTask = SFSpeechRecognitionTask()
    fileprivate var isRecording = false {
        didSet{
            if isRecording {
                recordingStateLabel.text = "Recording"
            }else{
                stopNoAudioDurationTimer()
                recordingStateLabel.text = "Stopped"
            }
        }
    }
    
    fileprivate var noAudioDurationTimer : Timer?
    fileprivate var noAudioDurationLimitSec: Int = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestSpeechAuthoriztation()
    }

    fileprivate func recordAndRecognizeSpeech(){
        let node = audioEngine.inputNode
        
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self](buffer, time) in
            guard let wSelf = self else {return}
        
            wSelf.request.append(buffer)

        }
    }
    
    fileprivate func startRecording(){
        recordAndRecognizeSpeech()
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print(error)
        }
        
        guard let myRecognizer = speechRecognizer else {
            //This recognizer is not supported for the 'en-US' locale
            //SFSpeechRecognizer() -> use this if you want to use the current locale
            return
        }
        
        guard myRecognizer.isAvailable else {
            // A recognizer is not avaliable right now.
            return
        }
        
        isRecording = true
        
        myRecognizer.recognitionTask(with: request, delegate: self)
        //OR
        /*recognitionTask = myRecognizer.recognitionTask(with: request, resultHandler: { [weak self](result, error) in
            guard let wSelf = self else {return}
            
            if let response = result {
              let detectedString = response.bestTranscription.formattedString
              wSelf.detectedTexts.text = detectedString
                
              for segment in response.bestTranscription.segments {
                let indexTo = detectedString.index(detectedString.startIndex, offsetBy: segment.substringRange.location)
                let lastString = detectedString[indexTo...]
                print(lastString)
              }
                
            }else if let err = error {
                print(err)
            }
        })*/
    }
    
    fileprivate func stopRecording(){
        if audioEngine.isRunning {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
            request.endAudio()
        }
        isRecording = false
    }
    
    @IBAction func actionWithRecognition(_ sender: Any) {
        if !isRecording {
            startRecording()
        }else{
            stopRecording()
        }
    }
    
    func requestSpeechAuthoriztation(){
        startStopButton.isEnabled = false
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.startStopButton.isEnabled = true
                    break
                case .denied:
                    break
                case .restricted:
                    break
                case .notDetermined:
                    break
                }
            }
        }
    }
    
    fileprivate func startNoAudioDurationTimer() {
        stopNoAudioDurationTimer()
        noAudioDurationTimer = Timer.scheduledTimer(
            timeInterval: TimeInterval(noAudioDurationLimitSec),
            target: self,
            selector:#selector(detectSilent),
            userInfo: nil,
            repeats: false
        )
    }
    
    fileprivate func stopNoAudioDurationTimer() {
        if noAudioDurationTimer != nil {
            noAudioDurationTimer?.invalidate()
            noAudioDurationTimer = nil
        }
    }
    
    @objc func detectSilent(){
        if isRecording {
            stopRecording()
        
            let alert = UIAlertController(title: "Alert", message: "Detected Silent", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
}


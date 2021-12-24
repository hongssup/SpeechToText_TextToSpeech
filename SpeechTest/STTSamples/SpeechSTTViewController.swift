//
//  SpeechSTTViewController.swift
//  SpeechTest
//
//  Created by SeoYeon Hong on 2021/12/23.
//

import UIKit
import Speech

class SpeechSTTViewController: UIViewController, SFSpeechRecognizerDelegate {

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var textView: UITextView!
    
    let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "ko-KR"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?  //음성인식
    private var recognitionTask: SFSpeechRecognitionTask?  //인식결과
    private let audioEngine = AVAudioEngine()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        speechRecognizer?.delegate = self
    }
    
    @IBAction func speechToText(_ sender: Any) {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            button.isEnabled = false
            button.setTitle("말하기", for: .normal)
        } else {
            startRecording()
            button.setTitle("멈추기", for: .normal)
        }
    }
    
    func startRecording() {
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.record)  //녹음
            try audioSession.setMode(AVAudioSession.Mode.measurement)  //측정
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)  //활성화
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        let inputNode = audioEngine.inputNode
//        guard let inputNode = audioEngine.inputNode else {
//            fatalError("Audio engine has no input node")
//        }
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                
                self.textView.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.button.isEnabled = true
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        textView.text = "말해보세요 듣고있어요!"
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            button.isEnabled = true
        } else {
            button.isEnabled = false
        }
    }
}

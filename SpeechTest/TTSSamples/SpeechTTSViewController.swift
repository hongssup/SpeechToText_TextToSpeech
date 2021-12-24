//
//  SpeechTTSViewController.swift
//  SpeechTest
//
//  Created by SeoYeon Hong on 2021/12/24.
//

import UIKit
import AVFoundation

class SpeechTTSViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func textToSpeech(_ sender: Any) {
        let synthesizer = AVSpeechSynthesizer()
        let utterance = AVSpeechUtterance(string: "말좀 해보라고. 왜 말을 못해")
        //let utterance = AVSpeechUtterance(string: myTextView.text )
        utterance.voice = AVSpeechSynthesisVoice(language: "ko-KR")
        utterance.rate = 0.4
        //utterance.pitchMultiplier = 0.5
        synthesizer.speak(utterance)
    }
}

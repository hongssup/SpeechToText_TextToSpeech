//
//  GoogleTTSViewController.swift
//  SpeechTest
//
//  Created by SeoYeon Hong on 2021/12/24.
//

import UIKit

class GoogleTTSViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var speakButton: UIButton!
    
    @IBOutlet weak var voiceGenderControl: UISegmentedControl!
    @IBOutlet weak var voiceTypeControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func textToSpeech(_ sender: Any) {
        speakButton.setTitle("음성인식중입니다", for: .normal)
        speakButton.isEnabled = false
        speakButton.alpha = 0.6
        
        var voiceType: VoiceType = .undefined
        let gender = voiceGenderControl.titleForSegment(at: voiceGenderControl.selectedSegmentIndex)
        let type = voiceTypeControl.titleForSegment(at: voiceTypeControl.selectedSegmentIndex)
        if gender == "여자" && type == "하이톤" {
            voiceType = .standardFemale
        } else if gender == "여자" && type == "저음" {
            voiceType = .lowFemale
        } else if gender == "남자" && type == "하이톤" {
            voiceType = .standardMale
        } else if gender == "남자" && type == "저음" {
            voiceType = .lowMale
        }
        
        GoogleSpeechService.shared.speak(text: textView.text, voiceType: voiceType) {
            self.speakButton.setTitle("말하기", for: .normal)
            self.speakButton.isEnabled = true
            self.speakButton.alpha = 1
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
}

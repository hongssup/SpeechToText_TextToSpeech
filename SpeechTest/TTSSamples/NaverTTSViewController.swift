//
//  NaverTTSViewController.swift
//  SpeechTest
//
//  Created by SeoYeon Hong on 2021/12/29.
//

import UIKit
import Alamofire
import AVFoundation

class NaverTTSViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var voiceGenderControl: UISegmentedControl!
    @IBOutlet weak var voiceNameBtn: UIButton!
    @IBOutlet weak var voiceNameLabel: UILabel!
    @IBOutlet weak var voiceNameView: UIView!
    @IBOutlet weak var speakView: UIView!
    @IBOutlet weak var speakBtn: UIButton!
    var audio: AVAudioPlayer?
    let headers: HTTPHeaders = [
        "Content-Type":"application/x-www-form-urlencoded",
        "X-NCP-APIGW-API-KEY-ID":NAVER_CLIENT_ID,
        "X-NCP-APIGW-API-KEY":NAVER_CLIENT_SECRET
    ]
    var player = AVPlayer()
    var genderFemale = true
    let femaleVoice = ["나라":"nara", "민영":"nminyoung", "다인(아동)":"ndain", "혜리":"nes_c_hyeri", "보라":"nbora"]
    let maleVoice = ["진호":"jinho", "성훈":"nseonghoon", "하준(아동)":"nhajun", "재욱":"njaewook", "시윤":"nsiyoon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        voiceNameView.layer.borderWidth = 1
        voiceNameView.layer.borderColor = UIColor(red: 26/255, green: 190/255, blue: 88/255, alpha: 0.5).cgColor
        voiceNameView.layer.cornerRadius = 8
        speakView.layer.cornerRadius = 24
    }

    @IBAction func segChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            genderFemale = true
            voiceNameLabel.text = "나라"
        case 1:
            genderFemale = false
            voiceNameLabel.text = "진호"
        default:
            break
        }
    }
    
    @IBAction func onClickBtn(_ sender: UIButton) {
        switch sender {
        case speakBtn:
            if !(textView.text == "") {
                textToSpeech()
            } else {
                print("텍스트를 입력해주세요.")
            }
            break
        case voiceNameBtn:
            let gender = voiceGenderControl.titleForSegment(at: voiceGenderControl.selectedSegmentIndex)
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            if genderFemale {
                for key in femaleVoice.keys {
                    actionSheet.addAction(UIAlertAction(title: key, style: .default, handler: { _ in
                        self.voiceNameLabel.text = key
                    }))
                }
            } else {
                for key in maleVoice.keys {
                    actionSheet.addAction(UIAlertAction(title: key, style: .default, handler: { _ in
                        self.voiceNameLabel.text = key
                    }))
                }
            }
            self.present(actionSheet, animated: true)
            
            break
        default:
            break
        }
    }
    
    func textToSpeech() {
        var params : [String:Any] = [:]
        if genderFemale {
            params.updateValue(femaleVoice[voiceNameLabel.text!]!, forKey: "speaker")
        } else {
            params.updateValue(maleVoice[voiceNameLabel.text!]!, forKey: "speaker")
        }
        params.updateValue(textView.text!, forKey: "text")
        
        AF.request(NAVER_TTS_URL, method: .post, parameters: params, headers: headers).responseData { response in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else { return }
                print("statusCode: \(statusCode)")
                guard let data = response.data else { return }
                self.play(data: data)
                break
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
        }
    }
    
    func play(data: Data) {
        do {
            audio = try AVAudioPlayer(data: data)
            audio?.prepareToPlay()
            audio?.play()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
}

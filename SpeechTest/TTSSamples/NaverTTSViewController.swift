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
    @IBOutlet weak var speakBtn: UIButton!
    var audio: AVAudioPlayer?
    let headers: HTTPHeaders = [
        "Content-Type":"application/x-www-form-urlencoded",
        "X-NCP-APIGW-API-KEY-ID":NAVER_CLIENT_ID,
        "X-NCP-APIGW-API-KEY":NAVER_CLIENT_SECRET
    ]
    var player = AVPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        default:
            break
        }
    }
    
    func textToSpeech() {
        var params : [String:Any] = [:]
        params.updateValue("nara", forKey: "speaker")
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

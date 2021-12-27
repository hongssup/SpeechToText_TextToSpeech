//
//  GoogleSTTViewController.swift
//  SpeechTest
//
//  Created by SeoYeon Hong on 2021/12/27.
//

import UIKit
import AVFoundation
import googleapis

let SAMPLE_RATE = 16000

class GoogleSTTViewController: UIViewController, AudioControllerDelegate {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var speakButton: UIButton!
    var audioData: NSMutableData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationItem.largeTitleDisplayMode = .never
        AudioController.sharedInstance.delegate = self
    }

    @IBAction func recordAudio(_ sender: Any) {
        print("들어옴")
        speakButton.alpha = 0.6
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.record)
        } catch {

        }
        audioData = NSMutableData()
        _ = AudioController.sharedInstance.prepare(specifiedSampleRate: SAMPLE_RATE)
        SpeechRecognitionService.sharedInstance.sampleRate = SAMPLE_RATE
        _ = AudioController.sharedInstance.start()
    }
    
    @IBAction func stopAudio(_ sender: Any) {
        _ = AudioController.sharedInstance.stop()
        SpeechRecognitionService.sharedInstance.stopStreaming()
    }
    
    func processSampleData(_ data: Data) -> Void {
      audioData.append(data)

      // We recommend sending samples in 100ms chunks
      let chunkSize : Int /* bytes/chunk */ = Int(0.1 /* seconds/chunk */
        * Double(SAMPLE_RATE) /* samples/second */
        * 2 /* bytes/sample */);

      if (audioData.length > chunkSize) {
        SpeechRecognitionService.sharedInstance.streamAudioData(audioData,
                                                                completion:
          { [weak self] (response, error) in
              guard let strongSelf = self else {
                  return
              }
              
              if let error = error {
                  print("error")
                  strongSelf.textView.text = error.localizedDescription
              } else if let response = response {
                  var finished = false
                  print("response: \(response)\n, description: \(response.description)")
                  for result in response.resultsArray! {
                      if let result = result as? StreamingRecognitionResult {
                          if result.isFinal {
                              
                              print("result: \(result.alternativesArray[0])")
                              let trans = result.alternativesArray[0] as? SpeechRecognitionAlternative
                              print("trans: \(trans?.transcript)")
                              finished = true
                              strongSelf.textView.text = trans?.transcript
                          }
                      }
                  }
                  //strongSelf.textView.text = response.description
                  if finished {
                      strongSelf.stopAudio(strongSelf)
                      self?.speakButton.alpha = 1
                  }
              }
        })
        self.audioData = NSMutableData()
      }
    }
}

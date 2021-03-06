//
//  SpeechViewController.swift
//  NYPITP312
//
//  Created by Ng Wan Ying on 6/8/17.
//  Copyright © 2017 NYP. All rights reserved.
//

//
//  SpeechViewController.swift
//  FairpriceShareTextbook
//
//  Created by Ng Wan Ying on 31/7/17.
//  Copyright © 2017 NYP. All rights reserved.
//

//
// Copyright 2016 Google Inc. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
import UIKit
import AVFoundation
import googleapis

let SAMPLE_RATE = 16000

class SpeechViewController : UIViewController, AudioControllerDelegate {
    @IBOutlet weak var textView: UITextView!
    var audioData: NSMutableData!
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    var bookName : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AudioController.sharedInstance.delegate = self
        
        myUtterance = AVSpeechUtterance(string: "Hi, you are currently in the donate tab, click on the mic and tell me the book name you are donating")
        myUtterance.pitchMultiplier = 1
        myUtterance.rate = 0.5
        synth.speak(myUtterance)
    }
    
    @IBAction func recordAudio(_ sender: NSObject) {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
        } catch {
            
        }
        audioData = NSMutableData()
        _ = AudioController.sharedInstance.prepare(specifiedSampleRate: SAMPLE_RATE)
        SpeechRecognitionService.sharedInstance.sampleRate = SAMPLE_RATE
        _ = AudioController.sharedInstance.start()
    }
    
    @IBAction func stopAudio(_ sender: NSObject) {
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
                        strongSelf.textView.text = error.localizedDescription
                    } else if let response = response {
                        var finished = false
                        print(response)
                        for result in response.resultsArray! {
                            if let result = result as? StreamingRecognitionResult {
                                if result.isFinal {
                                    finished = true
                                }
                            }
                        }
                        strongSelf.textView.text = response.description
                     
                        if finished {
                            strongSelf.stopAudio(strongSelf)
                            print(response.resultsArray_Count)
                            strongSelf.bookName = response.resultsArray.description
                            print(strongSelf.bookName)
                            for object in response.resultsArray {
                                if let object = object as? StreamingRecognizeResponse {
                                    print(object.resultsArray[0])
                                }
                            }
                        }
                    }
            })
            self.audioData = NSMutableData()
        }
    }
}

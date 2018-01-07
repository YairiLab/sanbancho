//
//  YLSpeechSynthesizer.swift
//  Textbook
//
//  Created by Hiloki OE on 9/24/14.
//  Copyright (c) 2014 sophia univ. All rights reserved.
//

import AVFoundation

public class MSSpeechSynthesizer: NSObject {
    let _speaker: AVSpeechSynthesizer
    let _voice:   AVSpeechSynthesisVoice
    
    public override init() {
        _speaker = AVSpeechSynthesizer()
        _voice = AVSpeechSynthesisVoice(language: "en-us")!
    }
    
    public func speak(_ s: String) {
        if _speaker.isSpeaking {
            _speaker.stopSpeaking(at: .immediate)
        }
        let ut = AVSpeechUtterance(string: s)
        ut.voice = _voice
        ut.rate = 0.5
        _speaker.speak(ut)
    }
}

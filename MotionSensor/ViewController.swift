//
//  ViewController.swift
//  WheelchairSensor
//
//  Created by Phil Owen on 10/18/15.
//  Copyright © 2015 Phil Owen. All rights reserved.
//

import UIKit
import C4

class ViewController: CanvasController, MSPeripheralManagerDelegate {
    var timer     : C4.Timer? = nil
    var logger    : MSLog? = nil
    let startTime = Date()
    let sensor    = MSSensor()
    let speaker   = MSSpeechSynthesizer()
    var peripheral: MSPeripheralManager!
    var prevData  : (Vector?, Vector?)
    
    var gyroView: MSBarView!
    var accView : MSBarView!
    var label   : TextShape!
    
    override func setup() {
        gyroView = MSBarView.attach(canvas: canvas, frame: Rect(20,  80, 280, 200))
        accView  = MSBarView.attach(canvas: canvas, frame: Rect(20, 320, 280, 200))
        label    = createLabel("init")
        canvas.add(label)
        
        let gesture = canvas.addTapGestureRecognizer { _, _, _ in
            self.tapped()
        }
        gesture.numberOfTapsRequired = 3
        
        peripheral = MSPeripheralManager(delegate: self)
    }
    
    
    func startUpdate() {
        sensor.start()
        canvas.backgroundColor = C4Pink
        timer = C4.Timer(interval: 0.02) { () in
            self.tick()
        }
        timer?.start()
    }
    
    func stopUpdate() {
        sensor.stop()
        canvas.backgroundColor = C4Grey
        if let t = timer {
            t.stop()
            timer = nil
        }
    }
    
    func startLogging() {
        if let _ = logger {
            stopLogging()
        }
        speak("log start")
        logger = MSLog.open(filename: MSLog.makeFileName(date: startTime))
    }
    
    func stopLogging() {
        if let l = logger {
            speak("log stop")
            l.close()
            logger = nil
        }
    }
    
    func beep() {
        speak("peep")
    }
    
    func getData() -> (Vector?, Vector?) {
        return prevData
    }
    
    func log(_ s: String) {
        canvas.remove(label)
        label = createLabel(s)
        canvas.add(label)
    }
    
    func speak(_ s: String) {
        speaker.speak(s)
    }
    
    func introduce() {
        speak(UIDevice.current.name)
    }
    
    func tick() {
        prevData = sensor.getData()
        let (r, a) = prevData
        if let data = r {
            gyroView.updateData(data: data)
        } else {
            print("failed to get gyro data")
        }
        if let data = a {
            accView.updateData(data: data)
        } else {
            print("failed to get acc data")
        }
        logger?.write(tickCount: -startTime.timeIntervalSinceNow, gyro: r, acc: a)
    }
    
    func tapped() {
        beep()
        if let _ = timer {
            stopLogging()
            stopUpdate()
        } else {
            startUpdate()
            startLogging()
        }
    }

    private func createLabel(_ s: String) -> TextShape {
        let label       = TextShape(text: s, font: Font(name: "Helvetica", size: 28)!)!
        label.center    = Point(canvas.center.x, 40)
        label.fillColor = lightGray
        return label
    }
}


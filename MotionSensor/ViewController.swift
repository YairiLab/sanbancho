//
//  ViewController.swift
//  WheelchairSensor
//
//  Created by Phil Owen on 10/18/15.
//  Copyright © 2015 Phil Owen. All rights reserved.
//

import UIKit
import CoreMotion
import AVFoundation
import CoreBluetooth
import C4

class ViewController: CanvasController, MSPeripheralManagerDelegate {
    var timer: C4.Timer? = nil
    var logger: MSLog? = nil
    let startTime = NSDate()
    let sensor = MSSensor()
    let speaker = MSSpeechSynthesizer()
    var peripheral: MSPeripheralManager!
    var prevData: (Vector?, Vector?)
    
    @IBOutlet weak var gyroView: MSBarView!
    @IBOutlet weak var accView: MSBarView!
    @IBOutlet weak var label: UILabel!
    
    override func setup() {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(ViewController.tapped))
        gesture.numberOfTapsRequired = 3
        view.addGestureRecognizer(gesture)
        
        peripheral = MSPeripheralManager(delegate: self)

        let rectangle = Rectangle(frame: Rect(0, 0, 100, 200))
        canvas.add(rectangle)
    }
    
    @objc func tapped(sender: UITapGestureRecognizer) {
        beep()
        if let _ = timer {
            stopLogging()
            stopUpdate()
        } else {
            startUpdate()
            startLogging()
        }
    }
    
    func startUpdate() {
        sensor.start()
        view.backgroundColor = UIColor.red
        timer = C4.Timer(interval: 0.02) { () in
            self.tick()
        }
    }
    
    func stopUpdate() {
        sensor.stop()
        view.backgroundColor = UIColor.darkGray
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
        logger = MSLog.open(filename: MSLog.makeFileName(date: startTime as Date))
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
        label.text = s
        print(s)
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
            gyroView.updateData(data: [data.x, data.y, data.z])
        } else {
            print("failed to get gyro data")
        }
        if let data = a {
            accView.updateData(data: [data.x, data.y, data.z])
        } else {
            print("failed to get acc data")
        }
        logger?.write(tickCount: -startTime.timeIntervalSinceNow, gyro: r, acc: a)
    }
}


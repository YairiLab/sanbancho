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

class ViewController: UIViewController, MSPeripheralManagerDelegate {
    var timer: NSTimer? = nil
    var logger: MSLog? = nil
    let startTime = NSDate()
    let sensor = MSSensor()
    let speaker = MSSpeechSynthesizer()
    var peripheral: MSPeripheralManager!
    var prevData: (Vector3D?, Vector3D?)
    
    @IBOutlet weak var gyroView: MSBarView!
    @IBOutlet weak var accView: MSBarView!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(ViewController.tapped(_:)))
        gesture.numberOfTapsRequired = 3
        view.addGestureRecognizer(gesture)
        
        peripheral = MSPeripheralManager(delegate: self)
    }
    
    func tapped(sender: UITapGestureRecognizer) {
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
        view.backgroundColor = UIColor.redColor()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.02,
            target: self, selector: #selector(ViewController.tick(_:)), userInfo: nil, repeats: true)
    }
    func stopUpdate() {
        sensor.stop()
        view.backgroundColor = UIColor.darkGrayColor()
        if let t = timer {
            t.invalidate()
            timer = nil
        }
    }
    
    func startLogging() {
        if let _ = logger {
            stopLogging()
        }
        speak("log start")
        logger = MSLog.open(MSLog.makeFileName(startTime))
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
    
    func getData() -> (Vector3D?, Vector3D?) {
        return prevData
    }
    
    func log(s: String) {
        label.text = s
        print(s)
    }
    
    func speak(s: String) {
        speaker.speak(s)
    }
    
    func introduce() {
        speak(UIDevice.currentDevice().name)
    }
    
    func tick(timer: NSTimer) {
        prevData = sensor.getData()
        let (r, a) = prevData
        if let data = r {
            gyroView.updateData([data.0, data.1, data.2])
        } else {
            print("failed to get gyro data")
        }
        if let data = a {
            accView.updateData([data.0, data.1, data.2])
        } else {
            print("failed to get acc data")
        }
        logger?.write(-startTime.timeIntervalSinceNow, gyro: r, acc: a)
    }
}


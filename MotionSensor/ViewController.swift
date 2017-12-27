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
    var timer: Timer? = nil
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
        gesture.addTarget(self, action: #selector(ViewController.tapped))
        gesture.numberOfTapsRequired = 3
        view.addGestureRecognizer(gesture)
        
        peripheral = MSPeripheralManager(delegate: self)
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
        timer = Timer.scheduledTimer(timeInterval: 0.02,
            target: self, selector: #selector(ViewController.tick), userInfo: nil, repeats: true)
    }
    func stopUpdate() {
        sensor.stop()
        view.backgroundColor = UIColor.darkGray
        if let t = timer {
            t.invalidate()
            timer = nil
        }
    }
    
    func startLogging() {
        if let _ = logger {
            stopLogging()
        }
        speak(s: "log start")
        logger = MSLog.open(filename: MSLog.makeFileName(date: startTime as Date))
    }
    
    func stopLogging() {
        if let l = logger {
            speak(s: "log stop")
            l.close()
            logger = nil
        }
    }
    
    func beep() {
        speak(s: "peep")
    }
    
    func getData() -> (Vector3D?, Vector3D?) {
        return prevData
    }
    
    func log(s: String) {
        label.text = s
        print(s)
    }
    
    func speak(s: String) {
        speaker.speak(s: s)
    }
    
    func introduce() {
        speak(s: UIDevice.current.name)
    }
    
    @objc func tick(timer: Timer) {
        prevData = sensor.getData()
        let (r, a) = prevData
        if let data = r {
            gyroView.updateData(data: [data.0, data.1, data.2])
        } else {
            print("failed to get gyro data")
        }
        if let data = a {
            accView.updateData(data: [data.0, data.1, data.2])
        } else {
            print("failed to get acc data")
        }
        logger?.write(tickCount: -startTime.timeIntervalSinceNow, gyro: r, acc: a)
    }
}


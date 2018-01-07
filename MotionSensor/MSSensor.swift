//
//  YLSensor.swift
//  WheelchairSensor
//
//  Created by Phil Owen on 10/20/15.
//  Copyright © 2015 Phil Owen. All rights reserved.
//

import Foundation
import CoreMotion
import C4

class MSSensor: NSObject {
    let motion = CMMotionManager()
    
    func start() {
        motion.startAccelerometerUpdates()
        motion.startGyroUpdates()
    }
    
    func stop() {
        motion.stopAccelerometerUpdates()
        motion.stopGyroUpdates()
    }
    
    func getRotationRate() -> Vector? {
        if let data = motion.gyroData {
            let r = data.rotationRate
            return Vector(x: r.x, y: r.y, z: r.z)
        } else {
            return nil
        }
    }

    func getAcceleration() -> Vector? {
        if let data = motion.accelerometerData {
            let a = data.acceleration
            return Vector(x: a.x, y: a.y, z: a.z)
        } else {
            return nil
        }
    }
    
    func getData() -> (Vector?, Vector?) {
        return (getRotationRate(), getAcceleration())
    }
}

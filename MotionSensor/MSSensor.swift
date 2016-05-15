//
//  YLSensor.swift
//  WheelchairSensor
//
//  Created by Phil Owen on 10/20/15.
//  Copyright © 2015 Phil Owen. All rights reserved.
//

import Foundation
import CoreMotion

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
    
    func getRotationRate() -> Vector3D? {
        if let data = motion.gyroData {
            let r = data.rotationRate
            return (r.x, r.y, r.z)
        } else {
            return nil
        }
    }

    func getAcceleration() -> Vector3D? {
        if let data = motion.accelerometerData {
            let a = data.acceleration
            return (a.x, a.y, a.z)
        } else {
            return nil
        }
    }
    
    func getData() -> (Vector3D?, Vector3D?) {
        return (getRotationRate(), getAcceleration())
    }
}
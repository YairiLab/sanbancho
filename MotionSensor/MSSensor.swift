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
    let _motion = CMMotionManager()
    
    func start() {
        _motion.startAccelerometerUpdates()
        _motion.startGyroUpdates()
    }
    
    func stop() {
        _motion.stopAccelerometerUpdates()
        _motion.stopGyroUpdates()
    }
    
    func getRotationRate() -> Vector? {
        guard let data = _motion.gyroData else {
            return nil
        }
        let r = data.rotationRate
        return Vector(x: r.x, y: r.y, z: r.z)
    }

    func getAcceleration() -> Vector? {
        guard let data = _motion.accelerometerData else {
            return nil
        }
        let a = data.acceleration
        return Vector(x: a.x, y: a.y, z: a.z)
    }
    
    func getData() -> (Vector?, Vector?) {
        return (getRotationRate(), getAcceleration())
    }
}

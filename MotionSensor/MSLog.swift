//
//  YLLog.swift
//  WheelchairSensor
//
//  Created by Phil Owen on 10/22/15.
//  Copyright © 2015 Phil Owen. All rights reserved.
//

import CoreLocation

class MSLog {
    let file: NSFileHandle
    init(file: NSFileHandle) {
        self.file = file
    }
    
    func write(tickCount: Double, gyro: Vector3D?, acc: Vector3D?) {
        let tick = NSString(format: "%.13f", tickCount)
        let sGyro = gyro != nil ? NSString(format: "%.13f,%.13f,%.13f", gyro!.0, gyro!.1, gyro!.2) : ",,"
        let sAcc = acc != nil ? NSString(format: "%.13f,%.13f,%.13f", acc!.0, acc!.1, acc!.2) : ",,"
        let line = "\(tick),\(sGyro),\(sAcc)\n"
        file.writeData(line.dataUsingEncoding(NSUTF8StringEncoding)!)
    }
    
    func close() {
        file.closeFile()
    }
    
    class func open(filename: String) -> MSLog {
        let fullpath = MSResource.getDocDirURL().path!
                + "/" + filename
        MSResource.createFile(fullpath)
        let file = NSFileHandle(forWritingAtPath: fullpath)
        return MSLog(file: file!)
    }
    
    class func makeFileName(date: NSDate) -> String {
        let format = NSDateFormatter()
        format.dateFormat = "yyyyMMdd_HHmmss"
        return format.stringFromDate(date) + ".csv"
    }

}
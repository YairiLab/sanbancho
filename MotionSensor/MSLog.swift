//
//  YLLog.swift
//  WheelchairSensor
//
//  Created by Phil Owen on 10/22/15.
//  Copyright © 2015 Phil Owen. All rights reserved.
//

import CoreLocation
import C4

class MSLog {
    let file: FileHandle
    init(file: FileHandle) {
        self.file = file
    }
    
    func write(tickCount: Double, gyro: Vector?, acc: Vector?) {
        let tick = NSString(format: "%.13f", tickCount)
        let sGyro = gyro != nil ? NSString(format: "%.13f,%.13f,%.13f", gyro!.x, gyro!.y, gyro!.z) : ",,"
        let sAcc = acc != nil ? NSString(format: "%.13f,%.13f,%.13f", acc!.x, acc!.y, acc!.z) : ",,"
        let line = "\(tick),\(sGyro),\(sAcc)\n"
        file.write(line.data(using: String.Encoding.utf8)!)
    }
    
    func close() {
        file.closeFile()
    }
    
    class func open(filename: String) -> MSLog {
        let fullpath = MSResource.getDocDirURL().path!
                + "/" + filename
        MSResource.createFile(path: fullpath)
        let file = FileHandle(forWritingAtPath: fullpath)
        return MSLog(file: file!)
    }
    
    class func makeFileName(date: Date) -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyyMMdd_HHmmss"
        return format.string(from: date) + ".csv"
    }

}

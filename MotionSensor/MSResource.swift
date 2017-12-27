//
//  YLResource.swift
//  WheelchairSensor
//
//  Created by Phil Owen on 10/20/15.
//  Copyright © 2015 Phil Owen. All rights reserved.
//

import Foundation

class MSResource {
    class func getURL(name: String, type: String) -> URL {
        return Bundle.main.url(forResource: name, withExtension: type)!
    }

    class func loadBundleResource(name: String, type: String) -> NSData {
        let url = getURL(name: name, type: type)
        return NSData(contentsOf: url)!
    }

    class func getDocDirURL() -> NSURL {
        let docDir = "\(NSHomeDirectory())/Documents/"
        return NSURL(fileURLWithPath: docDir)
    }
    
    class func createFile(path: String) {
        let manager = FileManager.default
        manager.createFile(atPath: path, contents: nil, attributes: nil)
    }
}


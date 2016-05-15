//
//  YLResource.swift
//  WheelchairSensor
//
//  Created by Phil Owen on 10/20/15.
//  Copyright © 2015 Phil Owen. All rights reserved.
//

import Foundation

class MSResource {
    class func getURL(name: String, type: String) -> NSURL {
        return NSBundle.mainBundle().URLForResource(name, withExtension: type)!
    }

    class func loadBundleResource(name: String, type: String) -> NSData {
        let url = getURL(name, type: type)
        return NSData(contentsOfURL: url)!
    }

    class func getDocDirURL() -> NSURL {
        let docDir = "\(NSHomeDirectory())/Documents/"
        return NSURL(fileURLWithPath: docDir)
    }
    
    class func createFile(path: String) {
        let manager = NSFileManager.defaultManager()
        manager.createFileAtPath(path, contents: nil, attributes: nil)
    }
}


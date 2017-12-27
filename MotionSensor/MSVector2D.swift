//
//  YLVector2D.swift
//  WheelchairSensor
//
//  Created by Phil Owen on 10/20/15.
//  Copyright © 2015 Phil Owen. All rights reserved.
//

import Foundation
import UIKit

typealias Vector3D = (Double, Double, Double)

public class MSVector2D {
    public let x: Double
    public let y: Double
    
    public init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
    
    public convenience init(xf: CGFloat, yf: CGFloat) {
        self.init(x: Double(xf), y: Double(yf))
    }
    
    public convenience init(point: CGPoint) {
        self.init(xf: point.x, yf: point.y)
    }
    
    public var description: String {
        get {
            return "(\(x), \(y))"
        }
    }
    
    public class var origin: MSVector2D {
        get {
            return MSVector2D(x: 50, y: 50)
        }
    }
    public class var zero: MSVector2D {
        get {
            return MSVector2D(x: 0, y: 0)
        }
    }
    
    public func toCGPoint() -> CGPoint {
        return CGPoint(x: CGFloat(x), y: CGFloat(y))
    }
}

func + (left: MSVector2D, right: MSVector2D) -> MSVector2D {
    return MSVector2D(x: left.x+right.x, y: left.y+right.y)
}

func * (left: MSVector2D, right: Double) -> MSVector2D {
    return MSVector2D(x: left.x*right, y: left.y*right)
}

func * (left: Double, right: MSVector2D) -> MSVector2D {
    return right * left
}
func - (left: MSVector2D, right: MSVector2D) -> MSVector2D {
    return MSVector2D(x: left.x-right.x, y: left.y-right.y)
}

func == (left: MSVector2D, right: MSVector2D) -> Bool {
    return (left.x == right.x) && (left.y == right.y)
}

func != (left: MSVector2D, right: MSVector2D) -> Bool {
    return !(left == right)
}

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x+right.x, y: left.y+right.y)
}


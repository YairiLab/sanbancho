//
//  YLBarView.swift
//  WheelchairSensor
//
//  Created by Phil Owen on 10/22/15.
//  Copyright © 2015 Phil Owen. All rights reserved.
//

import UIKit
import C4

class MSBarView: UIView {
    private var data: [Double] = []
    
    var relativeCenter: Vector {
        get {
            let size = self.frame.size
            return Vector(x: Double(size.width/2), y: Double(size.height/2))
        }
    }
    
    func updateData(data: [Double]) {
        self.data = data
        setNeedsDisplay()
    }
    
    func getDataTriple() -> Vector? {
        if !data.isEmpty {
            return Vector(x: data[0], y: data[1], z: data[2])
        } else {
            return nil
        }
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if let v = getDataTriple() {
            let rs = [v.x, v.y, v.z].enumerated().map { elem in toCGRect(i: elem.offset, x: elem.element) }
            for r in rs {
                drawBar(rect: r)
            }
        }
    }
    
    func toCGRect(i: Int, x: Double) -> CGRect {
        let w = Double(frame.width)
        let h = Double(frame.height)
        return CGRect(x: w/2, y: 30+(h/4)*Double(i), width: 70 * x, height: h/5)
    }
    
    func drawBar(rect: CGRect) {
        let bezier = UIBezierPath(rect: rect)
        UIColor.blue.setFill()
        bezier.fill()
    }
}

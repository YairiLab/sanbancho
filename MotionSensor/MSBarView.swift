//
//  YLBarView.swift
//  WheelchairSensor
//
//  Created by Phil Owen on 10/22/15.
//  Copyright © 2015 Phil Owen. All rights reserved.
//

import UIKit

class MSBarView: UIView {
    private var data: [Double] = []
    
    var relativeCenter: MSVector2D {
        get {
            let size = self.frame.size
            return MSVector2D(xf: size.width/2, yf: size.height/2)
        }
    }
    
    func updateData(data: [Double]) {
        self.data = data
        setNeedsDisplay()
    }
    
    func getDataTriple() -> Vector3D? {
        if !data.isEmpty {
            return (data[0], data[1], data[2])
        } else {
            return nil
        }
    }

    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        if let (x, y, z) = getDataTriple() {
            let rs = [x, y, z].enumerate().map {(i, x) in toCGRect(i, x: x) }
            for r in rs {
                drawBar(r)
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
        UIColor.blueColor().setFill()
        bezier.fill()
    }
}

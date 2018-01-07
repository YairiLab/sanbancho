//
//  YLBarView.swift
//  WheelchairSensor
//
//  Created by Phil Owen on 10/22/15.
//  Copyright © 2015 Phil Owen. All rights reserved.
//

import UIKit
import C4

class MSBarView {
    private let _baseRectangle: Rectangle
    private let _rectangles   : [Rectangle]
    private var _data         : Vector? = nil
    
    class func attach(canvas: View, frame: Rect) -> MSBarView {
        let view = MSBarView(frame)
        canvas.add(view._baseRectangle)
        for r in view._rectangles {
            canvas.add(r)
        }
        return view
    }
    private init(_ frame: Rect) {
        _baseRectangle = Rectangle(frame: frame)
        _baseRectangle.fillColor = C4Grey
        _rectangles = [1, 2, 3].map { _ in
            let r = Rectangle()
            r.corner = Size()
            r.strokeColor = nil
            r.fillColor = blue
            return r
        }
    }

    func updateData(data: Vector) {
        self._data = data
        if let v = _data {
            zip([v.x, v.y, v.z], _rectangles).enumerated().forEach { (offset, elem) in
                let rect = elem.1
                let frame = calcFrame(i: offset, x: elem.0)
                rect.frame = frame
            }
        }
    }

    func calcFrame(i: Int, x: Double) -> Rect {
        let w0 = _baseRectangle.width
        let h0 = _baseRectangle.height
        let size   = Size(0.2*abs(x)*w0, 0.2*h0)
        var center = _baseRectangle.center
        center.x = 0 < x ? center.x : center.x - size.width
        center.y += -1.3 * size.height * Double(i-1) - 20
        return Rect(center, size)
    }
}


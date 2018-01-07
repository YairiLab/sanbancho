//
//  MSPeripheralManagerDelegate.swift
//  MotionSensor
//
//  Created by Owen Hi Loki on 2018/01/07.
//  Copyright © 2018 Phil Owen. All rights reserved.
//

import Foundation
import C4

protocol MSPeripheralManagerDelegate {
    func log(_ s: String)
    func getData() -> (Vector?, Vector?)
    func startLogging()
    func stopLogging()
    func startUpdate()
    func stopUpdate()
    func beep()
    func speak(_ s: String)
    func introduce()
}

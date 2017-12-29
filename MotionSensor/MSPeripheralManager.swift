//
//  YLPeripheralManager.swift
//  WheelchairSensor
//
//  Created by Phil Owen on 11/23/15.
//  Copyright © 2015 Phil Owen. All rights reserved.
//

import UIKit
import CoreBluetooth

protocol MSPeripheralManagerDelegate {
    func log(s: String)
    func getData() -> (Vector3D?, Vector3D?)
    func startLogging()
    func stopLogging()
    func startUpdate()
    func stopUpdate()
    func beep()
    func speak(s: String)
    func introduce()
}

class MSPeripheralManager: NSObject, CBPeripheralManagerDelegate {
    let delegate: MSPeripheralManagerDelegate
    var _manager: CBPeripheralManager!
    let _service: CBMutableService!
    let _characteristic: CBMutableCharacteristic!
    
    static let charUuid = CBUUID(string: "EA644349-F3DC-48C9-BD8C-4394434A21C0")
    static let servUuid = CBUUID(string: "47603621-4AE3-4E44-92D9-64688AD8D6FB")
    
    init(delegate: MSPeripheralManagerDelegate) {
        self.delegate = delegate
        _manager = nil
        _characteristic = CBMutableCharacteristic(
                        type: MSPeripheralManager.charUuid,
                        properties: [.read, .write, .notify],
                        value: nil,
                        permissions: [.readable, .writeable])
        
        let service = CBMutableService(type: MSPeripheralManager.servUuid, primary: true)
        service.characteristics = [_characteristic]
        _service = service
        super.init()
        _manager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    // CBPeripheralManagerがインスタンス化されて、状態が変わったら呼ばれる
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        delegate.log(s: "state: \(peripheral.state.rawValue)")
        _manager!.add(_service)
        let data = [CBAdvertisementDataServiceUUIDsKey: [MSPeripheralManager.servUuid]]
        _manager!.startAdvertising(data)
    }
    
    // 宣伝を開始したら呼ばれる
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        if let e = error {
            delegate.log(s: "ERROR: \(e)")
        } else {
            delegate.log(s: "advertise started")
        }
    }
    
    // セントラルからデータが書き込まれたら呼ばれる
    func peripheralManager(
                    _ peripheral: CBPeripheralManager,
                    didReceiveWrite requests: [CBATTRequest]) {
        let req = requests.first
        let s = NSString(data: req!.value!, encoding: String.Encoding.utf8.rawValue)!
        let arr = s.components(separatedBy: ":")
        delegate.log(s: "command received: \(s)")
        switch(arr.first!) {
        case "start logging":
            delegate.startLogging()
        case "stop logging":
            delegate.stopLogging()
        case "start update":
            delegate.startUpdate()
        case "stop update":
            delegate.stopUpdate()
        case "start":
            delegate.startUpdate()
            delegate.startLogging()
        case "stop":
            delegate.stopLogging()
            delegate.stopUpdate()
        case "beep":
            delegate.beep()
        case "introduce":
            delegate.introduce()
        case "write":
            delegate.log(s: "\(arr[1])")
        default:
            _manager!.respond(to: req!, withResult: .invalidHandle)
        }
        _manager!.respond(to: requests.first!, withResult: .success)
    }
    // セントラルから読み込みリクエストが届いたら呼ばれる
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        let s = "\(delegate.getData())"
        request.value = s.data(using: String.Encoding.utf8, allowLossyConversion:true)
        _manager!.respond(to: request, withResult: .success)
    }
    
}


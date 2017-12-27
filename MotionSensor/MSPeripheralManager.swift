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
    var manager: CBPeripheralManager?

    static let charUuid = CBUUID(string: "EA644349-F3DC-48C9-BD8C-4394434A21C0")
    static let servUuid = CBUUID(string: "47603621-4AE3-4E44-92D9-64688AD8D6FB")
    
    init(delegate: MSPeripheralManagerDelegate) {
        self.delegate = delegate
        manager = nil
        super.init()
        manager = CBPeripheralManager(delegate: self, queue: nil)
        
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        delegate.log(s: "state: \(peripheral.state.rawValue)")
        let props: CBCharacteristicProperties = [.read, .write, .notify]
        let permissions: CBAttributePermissions = [.readable, .writeable]
        let characteristic = CBMutableCharacteristic(type: MSPeripheralManager.charUuid,
            properties: props, value: nil, permissions: permissions)

        let service = CBMutableService(type: MSPeripheralManager.servUuid, primary: true)
        service.characteristics = [characteristic]

        manager!.add(service)
        let data = [CBAdvertisementDataServiceUUIDsKey: [MSPeripheralManager.servUuid]]
        manager!.startAdvertising(data)
    }
    
    func peripheralManager(peripheral: CBPeripheralManager, didAddService service: CBService, error: NSError?) {
        if let e = error {
            delegate.log(s: "ERROR: \(e)")
        } else {
            delegate.log(s: "service added: \(service.uuid)")
        }
    }
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        if let e = error {
            delegate.log(s: "ERROR: \(e)")
        } else {
            delegate.log(s: "advertise started")
        }
    }
    
    func peripheralManager(peripheral: CBPeripheralManager, didReceiveWriteRequests requests: [CBATTRequest]) {
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
            manager!.respond(to: req!, withResult: .invalidHandle)
        }
        manager!.respond(to: requests.first!, withResult: .success)
    }
    
    func peripheralManager(peripheral: CBPeripheralManager, didReceiveReadRequest request: CBATTRequest) {
        let s = "\(delegate.getData())"
        request.value = s.data(using: String.Encoding.utf8, allowLossyConversion:true)
        manager!.respond(to: request, withResult: .success)
    }
    
}


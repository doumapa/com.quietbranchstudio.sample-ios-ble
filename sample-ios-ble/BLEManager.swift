//
//  BLEManager.swift
//  sample-ios-ble
//
//  Created by 金子実 on 2019/05/09.
//  Copyright © 2019 quiet branch studio. All rights reserved.
//

import Foundation
import CoreBluetooth
import ReactiveSwift

class BLEManager: NSObject {

  let DefaultScanDuration: TimeInterval = 5

  class func scan(duration: TimeInterval) -> SignalProducer<[CBPeripheral], Error> {
    return instance.scan(duration: duration)
  }
  
  class func connect(name: String) -> SignalProducer<Data, Error> {
    return instance.connect(name: name)
  }
  
  class func cancel() {
    return instance.cancel()
  }
  
  private class var instance: BLEManager {
    struct Static {
      static let instance = BLEManager()
    }
    return Static.instance
  }

  private var centralManager: CBCentralManager!
  private var scanDuration: TimeInterval
  private var advertisements: [[String : Any]] = [[String : Any]]()
  private var advertisement: [String : Any]?
  private var peripherals: [CBPeripheral] = [CBPeripheral]()
  private var peripheral: CBPeripheral?
  private var peripheralSignal: (output: Signal<Data, Error>, input: Signal<Data, Error>.Observer)

  private override init() {
    scanDuration = DefaultScanDuration
    peripheralSignal = Signal<Data, Error>.pipe()
    super.init()
    centralManager = CBCentralManager(delegate: self, queue: nil)
  }

  private func scan(duration: TimeInterval) -> SignalProducer<[CBPeripheral], Error> {
    return SignalProducer<[CBPeripheral], Error> { [weak self] (observable, _) in
      guard let centralManager = self?.centralManager else {
        observable.send(error: AppError.error(level: .fatal,
                                              reason: .internalAppError,
                                              title: nil,
                                              description: "USB機器に接続する準備ができていません。"))
        observable.sendCompleted()
        return
      }
      guard centralManager.state == .poweredOn else {
        observable.send(error: AppError.error(level: .warning,
                                              reason: .unexpected,
                                              title: nil,
                                              description: "USB機器に接続する準備ができていません。"))
        observable.sendCompleted()
        return
      }
      guard !centralManager.isScanning else {
        observable.send(error: AppError.error(level: .warning,
                                              reason: .unexpected,
                                              title: nil,
                                              description: "USB機器のスキャン中です。"))
        observable.sendCompleted()
        return
      }
      centralManager.scanForPeripherals(withServices: nil, options: nil)
      DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
        centralManager.stopScan()
        observable.send(value: self!.peripherals)
        observable.sendCompleted()
      }
    }
  }

  private func connect(name: String) -> SignalProducer<Data, Error> {
    guard !peripherals.isEmpty,
      let peripheral = peripherals.first(where: { (element: CBPeripheral) -> Bool in
        return element.name == name
      }) else {
        return SignalProducer(error: AppError.error(level: .warning,
                                                            reason: .unexpected,
                                                            title: nil,
                                                            description: "USB機器が見つかりません。"))
    }
    self.peripheral = peripheral

    guard !advertisements.isEmpty else {
        return SignalProducer(error: AppError.error(level: .warning,
                                                    reason: .unexpected,
                                                    title: nil,
                                                    description: "USB機器が見つかりません。"))
    }

    advertisements = advertisements.filter({ (element: [String : Any]) -> Bool in
      return element[CBAdvertisementDataLocalNameKey]! as! String == name
    })

    centralManager.connect(peripheral, options: nil)
    return SignalProducer<Data, Error>(peripheralSignal.output)
  }
  
  private func cancel() {
    guard let centralManager = centralManager else { return }
    if centralManager.isScanning {
      centralManager.stopScan()
    }
    if let peripheral = peripheral,
      peripheral.state == .connecting || peripheral.state == .connected {
      centralManager.cancelPeripheralConnection(peripheral)
    }
  }

}

extension BLEManager: CBCentralManagerDelegate {

  func centralManagerDidUpdateState(_ central: CBCentralManager) {
    print("centralManagerDidUpdateState")
  }

  func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
    if let _ = peripheral.name {
      peripherals.append(peripheral)
    }
    if let _ = advertisementData[CBAdvertisementDataLocalNameKey] {
      advertisements.append(advertisementData)
    }
  }

  func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
    peripheral.delegate = self
    peripheral.discoverServices(nil)
  }

  func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
    peripheralSignal.input.send(error: error ?? AppError.error(level: .fatal,
                                                               reason: .internalAppError,
                                                               title: nil,
                                                               description: "USB機器に接続できません。"))
  }
  
  func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {

  }

}

extension BLEManager: CBPeripheralDelegate {
  
  func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
    guard error == nil else {
      peripheralSignal.input.send(error: error!)
      return
    }
    guard let services = peripheral.services, !services.isEmpty else {
      peripheralSignal.input.send(error: AppError.error(level: .fatal,
                                                        reason: .unexpected,
                                                        title: nil,
                                                        description: "USB機器に有効なサービスがありません。"))
      return
    }
    guard let advertisement = advertisement,
      let service = services.first(where: { (element: CBService) -> Bool in
        element.uuid.uuidString == (advertisement[CBAdvertisementDataServiceUUIDsKey] as? NSArray)?.componentsJoined(by: "") ?? ""
      }) else {
        peripheralSignal.input.send(error: AppError.error(level: .fatal,
                                                          reason: .unexpected,
                                                          title: nil,
                                                          description: "USB機器に有効なサービスがありません。"))
        return
    }
    peripheral.discoverCharacteristics(nil, for: service)
  }
  
  func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
    guard error == nil else {
      peripheralSignal.input.send(error: error!)
      return
    }
    guard let characteristics = service.characteristics, !characteristics.isEmpty else {
      peripheralSignal.input.send(error: AppError.error(level: .fatal,
                                                        reason: .unexpected,
                                                        title: nil,
                                                        description: "USB機器に有効なサービスがありません。"))
      return
    }
  }
  
}

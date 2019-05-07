//
//  PeripheralViewController.swift
//  sample-ios-ble
//
//  Created by makoto kaneko on 2019/04/28.
//  Copyright © 2019 quiet branch studio. All rights reserved.
//

import UIKit
import CoreBluetooth

class PeripheralViewController: UIViewController {

  var viewModel: PeripheralViewModel? {
    get {
      return (view as! PeripheralView).viewModel ?? nil
    }
    set {
      (view as! PeripheralView).viewModel = newValue
      bind()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    configure()
  }
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */

  private var peripheralManager: CBPeripheralManager?
  private var characteristic: CBMutableCharacteristic?
  
  private func configure() {
    peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
  }
  
  private func bind() {
    guard let viewModel = viewModel else { return }
    
    viewModel.isActive.signal
    .take(duringLifetimeOf: self)
      .observeValues { [weak self] (isActive: Bool) in
        guard let peripheralManager = self?.peripheralManager else { return }
        if isActive {
          let data: [String : Any] = [
            CBAdvertisementDataLocalNameKey: "\(PeripheralModel.advertisementName)",
            CBAdvertisementDataServiceUUIDsKey: PeripheralModel.UUID.service.uuid
          ]
          peripheralManager.startAdvertising(data)
        } else {
          peripheralManager.stopAdvertising()
        }
    }

    viewModel.sendText.signal
      .take(duringLifetimeOf: self)
      .observeValues { [weak self] (text: String) in
        guard let peripheralManager = self?.peripheralManager else { return }
        guard let characteristic = self?.characteristic,
          let centrals = characteristic.subscribedCentrals, !centrals.isEmpty else { return }
        peripheralManager.updateValue(PeripheralModel(text: text).data, for: characteristic, onSubscribedCentrals: nil)
    }
  }
  
}

extension PeripheralViewController: CBPeripheralManagerDelegate {

  func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {




    guard let peripheralManager = peripheralManager, peripheral.state == .poweredOn else { return }
    let characteristic = CBMutableCharacteristic(type: PeripheralModel.UUID.characteristic.uuid,
                                                 properties: .notify,
                                                 value: nil,
                                                 permissions: .readable)
    let service = CBMutableService(type: PeripheralModel.UUID.service.uuid,
                                   primary: true)
    service.characteristics = [characteristic]
    self.characteristic = characteristic
    peripheralManager.add(service)
  }
  
  func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
    
  }
  
  func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
    
  }
  
  func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {

  }
  
  func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {

  }
  
  func peripheralManagerIsReady(toUpdateSubscribers peripheral: CBPeripheralManager) {

  }

  func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {

  }
  
  func peripheralManager(_ peripheral: CBPeripheralManager, willRestoreState dict: [String : Any]) {

  }
  
  func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {

  }
  
}

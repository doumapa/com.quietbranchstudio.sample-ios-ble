//
//  PeripheralModel.swift
//  sample-ios-ble
//
//  Created by 金子実 on 2019/05/07.
//  Copyright © 2019 quiet branch studio. All rights reserved.
//

import Foundation
import CoreBluetooth

struct PeripheralModel {

  var text: String

  init(text: String) {
    self.text = text
  }

  var data: Data {
    return Data(text.utf8)
  }

  enum UUID: String {

    case service =  "ble_service_0011"

    case characteristic = "ble_characteristic_0012"

    var uuid: CBUUID {
      return CBUUID(string: self.rawValue)
    }

  }

  static var advertisementName: String {
    get {
      return Defaults().value(forKey: .AdvertisementName) ?? "iPhone_BLE(001)"
    }
    set {
      Defaults().set(newValue, forKey: .AdvertisementName)
    }
  }

}

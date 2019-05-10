//
//  CentralViewController.swift
//  sample-ios-ble
//
//  Created by makoto kaneko on 2019/04/28.
//  Copyright © 2019 quiet branch studio. All rights reserved.
//

import UIKit
import CoreBluetooth
import ReactiveSwift

class CentralViewController: UIViewController {

  var viewModel: CentralViewModel? {
    get {
      return (view as! CentralView).viewModel ?? nil
    }
    set {
      (view as! CentralView).viewModel = newValue
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let viewModel = CentralViewModel()
    viewModel.scanAction = Action<Void, Void, Never> { _ in
      BLEManager.scan(duration: 5)
        .flatMap(.latest) { (peripherals: [CBPeripheral]) -> SignalProducer<Data, Error> in
        guard let peripheral = peripherals.first(where: { (element: CBPeripheral) -> Bool in
          guard let name = element.name else { return false }
          return name == "SamilD6F0FCEBD22F"
        }),
          let name = peripheral.name else {
            return SignalProducer(error: AppError.error(level: .warning,
                                                        reason: .unexpected,
                                                        title: nil,
                                                        description: "指定したUSB機器が見つかりませんでした。"))
        }
        return BLEManager.connect(name: name)
        }
        .on(failed: { (error: Error) in
          print("Failed: \(error)")
        })
        .retry(upTo: 5, interval: 3, on: QueueScheduler.main)
        .start { (event: Signal<Data, Error>.Event) in
          switch event {
          case let .value(next):
            print(next)
          case let .failed(error):
            print("Failed: \(error)")
          case .completed:
            print("Completed")
          case .interrupted:
            print("Interrupted")
          }
        }
      return SignalProducer.empty
    }
    
    self.viewModel = viewModel
  }
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */

}

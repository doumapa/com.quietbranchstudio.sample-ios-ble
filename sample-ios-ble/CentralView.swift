//
//  CentralView.swift
//  sample-ios-ble
//
//  Created by makoto kaneko on 2019/04/29.
//  Copyright © 2019 quiet branch studio. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class CentralView: UIView {

  @IBOutlet weak var peripheralNameField: UITextField!
  @IBOutlet weak var receiveTextLabel: UILabel!
  @IBOutlet weak var scanButton: UIButton!

  var viewModel: CentralViewModel? {
    didSet {
      bind()
    }
  }

  private func bind() {
    guard let viewModel = viewModel else { return }
    peripheralNameField.reactive.text <~ viewModel.peripheralName
    receiveTextLabel.reactive.text <~ viewModel.receiveText
    scanButton.reactive.pressed = CocoaAction(viewModel.scanAction)
  }
  
  /*
   // Only override draw() if you perform custom drawing.
   // An empty implementation adversely affects performance during animation.
   override func draw(_ rect: CGRect) {
   // Drawing code
   }
   */

}

class CentralViewModel {
  
  let peripheralName: MutableProperty<String>
  let scanAction: Action<Void, Void, Never>

  let receiveText: MutableProperty<String> = MutableProperty("")

  init(peripheral: String, validationRule: @escaping (String) -> Bool = validateCredentials) {
    let peripheralName = MutableProperty(peripheral)

    let isValid = MutableProperty(validationRule(peripheral))
    isValid <~ peripheralName.producer.map(validationRule)
    
    let scanAction = Action<Void, Void, Never>(enabledIf: isValid) { _ in
      return SignalProducer.empty
    }
    
    self.peripheralName = peripheralName
    self.scanAction = scanAction
  }

}

private func validateCredentials(peripheral: String) -> Bool {
  return peripheral.count > 0
}

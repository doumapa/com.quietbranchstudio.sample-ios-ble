//
//  PeripheralView.swift
//  sample-ios-ble
//
//  Created by makoto kaneko on 2019/04/29.
//  Copyright © 2019 quiet branch studio. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class PeripheralView: UIView {

  @IBOutlet weak var sendTextField: UITextField!
  @IBOutlet weak var sendButton: UIButton!

  var viewModel: PeripheralViewModel? {
    didSet {
      bind()
    }
  }

  private func bind() {
    guard let viewModel = viewModel else { return }
    
  }

  /*
   // Only override draw() if you perform custom drawing.
   // An empty implementation adversely affects performance during animation.
   override func draw(_ rect: CGRect) {
   // Drawing code
   }
   */

}

class PeripheralViewModel {

  let sendText: MutableProperty<String>
  let sendAction: Action<Void, Void, Never>

  init(validationRule: @escaping (String) -> Bool = validateCredentials) {
    let text = ""
    let sendText = MutableProperty(text)

    let isValid = MutableProperty(validationRule(text))
    isValid <~ sendText.producer.map(validationRule)
    
    let sendAction = Action<Void, Void, Never>(enabledIf: isValid) { _ in
      return SignalProducer.empty
    }

    self.sendText = sendText
    self.sendAction = sendAction
  }
  
}

private func validateCredentials(text: String) -> Bool {
  return text.count > 0
}

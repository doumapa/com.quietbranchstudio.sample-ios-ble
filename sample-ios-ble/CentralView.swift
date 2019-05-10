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
//    peripheralNameField.reactive.text <~ viewModel.peripheralName
//    receiveTextLabel.reactive.text <~ viewModel.receiveText
    if let scanAction = viewModel.scanAction {
      scanButton.reactive.pressed = CocoaAction(scanAction)
    }
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
  
  var scanAction: Action<Void, Void, Never>?

}

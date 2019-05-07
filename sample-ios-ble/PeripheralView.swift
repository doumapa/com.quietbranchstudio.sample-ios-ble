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

  @IBOutlet weak var peripheralStatusLabel: UILabel!
  @IBOutlet weak var advertisingSwitch: UISwitch!
  @IBOutlet weak var sendTextField: UITextField!
  @IBOutlet weak var sendButton: UIButton!

  var viewModel: PeripheralViewModel? {
    didSet {
      bind()
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    configure()
  }
  
  /*
   // Only override draw() if you perform custom drawing.
   // An empty implementation adversely affects performance during animation.
   override func draw(_ rect: CGRect) {
   // Drawing code
   }
   */

  private func configure() {
    advertisingSwitch.isOn = false
    sendTextField.isEnabled = false
    sendButton.isEnabled = false
    sendButton.setTitleColor(UIColor(named: "Form_Submit_Text_Enable") ?? UIColor.white,
                             for: .normal)
    sendButton.setTitleColor(UIColor(named: "Form_Submit_Text_Disable") ?? UIColor.white,
                             for: .disabled)
    sendButton.setBackgroundImage(UIImage.image(withColor: UIColor(named: "Form_Submit_Background_Enable") ?? UIColor.blue,
                                                size: CGSize(width: 1, height: 1)),
                                  for: .normal)
    sendButton.setBackgroundImage(UIImage.image(withColor: UIColor(named: "Form_Submit_Background_Disable") ?? UIColor.lightGray,
                                                size: CGSize(width: 1, height: 1)),
                                  for: .disabled)
  }
  
  private func bind() {
    guard let viewModel = viewModel else { return }

    peripheralStatusLabel.reactive.text <~ viewModel.peripheralStatusText

    viewModel.isActive <~ advertisingSwitch.reactive.isOnValues
    sendTextField.reactive.isEnabled <~ advertisingSwitch.reactive.isOnValues

    sendButton.reactive.isEnabled <~
      SignalProducer.combineLatest(sendTextField.reactive.continuousTextValues, advertisingSwitch.reactive.isOnValues)
        .flatMap(.latest) { (values: (text: String, isOn: Bool)) -> SignalProducer<Bool, Never> in
          return SignalProducer { observable, _ in
            observable.send(value: values.text.count > 0 && values.isOn)
            observable.sendCompleted()
          }
    }

    sendButton.reactive.pressed = CocoaAction(Action<Void, Void, Never> { [weak self] in
      viewModel.sendText.swap(self?.sendTextField.text ?? "")
      return SignalProducer.empty
    })
  }

}

class PeripheralViewModel {

  let peripheralStatusText: MutableProperty<String> = MutableProperty("")
  let isActive: MutableProperty<Bool> = MutableProperty(false)
  let sendText: MutableProperty<String> = MutableProperty("")

}

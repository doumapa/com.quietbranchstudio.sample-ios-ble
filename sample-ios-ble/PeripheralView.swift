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
    sendButton.isEnabled = false
    sendButton.setTitleColor(UIColor(named: "Form_Submit_Text_Enable") ?? UIColor.white,
                             for: .normal)
    sendButton.setBackgroundImage(UIImage.image(withColor: UIColor(named: "Form_Submit_Background_Enable") ?? UIColor.blue,
                                                size: CGSize(width: 1, height: 1)),
                                  for: .normal)
    sendButton.setTitleColor(UIColor(named: "Form_Submit_Text_Disable") ?? UIColor.white,
                             for: .disabled)
    sendButton.setBackgroundImage(UIImage.image(withColor: UIColor(named: "Form_Submit_Background_Disable") ?? UIColor.lightGray,
                                                size: CGSize(width: 1, height: 1)),
                                  for: .disabled)
  }
  
  private func bind() {
    guard let viewModel = viewModel else { return }
    
    viewModel.sendText <~ sendTextField.reactive.textValues
    
    sendButton.reactive.isEnabled <~
      sendTextField.reactive.continuousTextValues
        .take(duringLifetimeOf: self)
        .flatMap(.latest) { (text: String) -> SignalProducer<Bool, Never> in
          return SignalProducer { observable, _ in
            observable.send(value: text.count > 0)
            observable.sendCompleted()
          }
    }
    
    sendButton.reactive.pressed = CocoaAction(viewModel.sendAction)
  }

}

class PeripheralViewModel {

  let sendText: MutableProperty<String>
  let sendAction: Action<Void, Void, Never>

  init(validationRule: @escaping (String) -> Bool = validateCredentials) {
    let text = ""
    let sendText: MutableProperty<String> = MutableProperty(text)

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

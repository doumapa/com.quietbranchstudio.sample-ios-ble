//
//  PeripheralViewController.swift
//  sample-ios-ble
//
//  Created by makoto kaneko on 2019/04/28.
//  Copyright © 2019 quiet branch studio. All rights reserved.
//

import UIKit

class PeripheralViewController: UIViewController {

  var viewModel: PeripheralViewModel? {
    get {
      return (view as! PeripheralView).viewModel ?? nil
    }
    set {
      (view as! PeripheralView).viewModel = newValue
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
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

//
//  CentralViewController.swift
//  sample-ios-ble
//
//  Created by makoto kaneko on 2019/04/28.
//  Copyright © 2019 quiet branch studio. All rights reserved.
//

import UIKit

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

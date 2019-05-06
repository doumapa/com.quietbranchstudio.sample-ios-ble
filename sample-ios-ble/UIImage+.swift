//
//  UIImage+.swift
//  sample-ios-ble
//
//  Created by makoto kaneko on 2019/05/07.
//  Copyright © 2019 quiet branch studio. All rights reserved.
//

import UIKit

extension UIImage {

  class func image(withColor color: UIColor, size: CGSize) -> UIImage? {
    defer {
      UIGraphicsEndImageContext()
    }
    UIGraphicsBeginImageContext(size)
    guard let context = UIGraphicsGetCurrentContext() else { return nil }
    context.setFillColor(color.cgColor)
    context.fill(CGRect(origin: CGPoint.zero, size: size))
    return UIGraphicsGetImageFromCurrentImageContext()
  }

}

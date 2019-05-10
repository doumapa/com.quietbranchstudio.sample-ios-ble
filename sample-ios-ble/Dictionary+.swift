//
//  Dictionary+.swift
//  sample-ios-ble
//
//  Created by 金子実 on 2019/05/10.
//  Copyright © 2019 quiet branch studio. All rights reserved.
//

import Foundation

@dynamicMemberLookup
protocol DictionaryDynamicLookup {
  associatedtype Key
  associatedtype Value
  subscript(key: Key) -> Value? { get set }
}

extension DictionaryDynamicLookup where Key == String {
  subscript(dynamicMember member: String) -> Value? {
    get {
      return self[member]
    }
    set {
      self[member] = newValue
    }
  }
}

extension Dictionary: DictionaryDynamicLookup {}

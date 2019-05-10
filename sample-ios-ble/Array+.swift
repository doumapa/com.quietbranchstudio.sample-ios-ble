//
//  Array+.swift
//  sample-ios-ble
//
//  Created by 金子実 on 2019/05/10.
//  Copyright © 2019 quiet branch studio. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
  @discardableResult
  mutating func remove(_ element: Element) -> Index? {
    guard let index = firstIndex(of: element) else { return nil }
    remove(at: index)
    return index
  }
  
  @discardableResult
  mutating func remove(_ elements: [Element]) -> [Index] {
    return elements.compactMap { remove($0) }
  }
  
  func object(where predicate: (Element) throws -> Bool) -> Element? {
    guard let index = try? firstIndex(where: predicate) else { return nil }
    return self[index]
  }
}

extension Array where Element: Hashable {
  mutating func unify() {
    self = unified()
  }
}

extension Collection where Element: Hashable {
  func unified() -> [Element] {
    return reduce(into: []) {
      if !$0.contains($1) {
        $0.append($1)
      }
    }
  }
}

extension Collection {
  subscript(safe index: Index) -> Element? {
    return startIndex <= index && index < endIndex ? self[index] : nil
  }
}

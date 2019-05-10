//
//  Defaults.swift
//  sample-ios-ble
//
//  Created by 金子実 on 2019/05/07.
//  Copyright © 2019 quiet branch studio. All rights reserved.
//

import Foundation

protocol KeyNamespaceable {
  func namespaced<T: RawRepresentable>(_ key: T) -> String
}

// MARK: - キーの衝突を防ぐためにネームスペースを付加するプロトコル拡張実装
extension KeyNamespaceable {
  
  func namespaced<T: RawRepresentable>(_ key: T) -> String {
    return "\(Self.self).\(key.rawValue)"
  }
  
}

protocol StringKeySettable: KeyNamespaceable where StringKey.RawValue == String {
  associatedtype StringKey : RawRepresentable
}

protocol BoolKeySettable: KeyNamespaceable where BoolKey.RawValue == String {
  associatedtype BoolKey : RawRepresentable
}

protocol IntegerKeySettable: KeyNamespaceable where IntegerKey.RawValue == String {
  associatedtype IntegerKey : RawRepresentable
}

protocol ObjectKeySettable : KeyNamespaceable where ObjectKey.RawValue == String {
  associatedtype ObjectKey : RawRepresentable
}

// MARK: - 文字列キーのためのプロトコル拡張実装

protocol StringDefaultSettable: StringKeySettable {
}

extension StringDefaultSettable {
  
  func value(forKey key: StringKey) -> String? {
    let key = namespaced(key)
    return UserDefaults.standard.string(forKey: key)
  }
  
  func set(_ value: String?, forKey key: StringKey) {
    let key = namespaced(key)
    UserDefaults.standard.set(value, forKey: key)
  }
  
  func remove(forKey key: StringKey) {
    let key = namespaced(key)
    UserDefaults.standard.removeObject(forKey: key)
  }
  
  func exist(forKey key: StringKey) -> Bool {
    let key = namespaced(key)
    if UserDefaults.standard.dictionaryRepresentation().keys.contains(key),
      let _ = UserDefaults.standard.string(forKey: key) {
      return true
    } else {
      return false
    }
  }
  
}

// MARK: - Boolキーのためのプロトコル拡張実装

protocol BoolDefaultSettable: BoolKeySettable {
}

extension BoolDefaultSettable {
  
  func value(forKey key: BoolKey) -> Bool {
    let key = namespaced(key)
    return UserDefaults.standard.bool(forKey: key)
  }
  
  func set(_ value: Bool, forKey key: BoolKey) {
    let key = namespaced(key)
    UserDefaults.standard.set(value, forKey: key)
  }
  
  func remove(forKey key: BoolKey) {
    let key = namespaced(key)
    UserDefaults.standard.removeObject(forKey: key)
  }
  
  func exist(forKey key: BoolKey) -> Bool {
    let key = namespaced(key)
    return UserDefaults.standard.dictionaryRepresentation().keys.contains(key)
  }
  
}

// MARK: - Integerキーのためのプロトコル拡張実装

protocol IntegerDefaultSettable: IntegerKeySettable {
}

extension IntegerDefaultSettable {
  
  func value(forKey key: IntegerKey) -> Int {
    let key = namespaced(key)
    return UserDefaults.standard.integer(forKey: key)
  }
  
  func set(_ value: Int, forKey key: IntegerKey) {
    let key = namespaced(key)
    UserDefaults.standard.set(value, forKey: key)
  }
  
  func remove(forKey key: IntegerKey) {
    let key = namespaced(key)
    UserDefaults.standard.removeObject(forKey: key)
  }
  
  func exist(forKey key: IntegerKey) -> Bool {
    let key = namespaced(key)
    return UserDefaults.standard.dictionaryRepresentation().keys.contains(key)
  }
  
}

// MARK: - Objectキーのためのプロトコル拡張実装

protocol ObjectDefaultSettable: ObjectKeySettable {
}

extension ObjectDefaultSettable {
  
  func value(forKey key: ObjectKey) -> Any? {
    let key = namespaced(key)
    return UserDefaults.standard.object(forKey: key)
  }
  
  func set(_ value: Any?, forKey key: ObjectKey) {
    let key = namespaced(key)
    UserDefaults.standard.set(value, forKey: key)
  }
  
  func remove(forKey key: ObjectKey) {
    let key = namespaced(key)
    UserDefaults.standard.removeObject(forKey: key)
  }
  
  func exist(forKey key: ObjectKey) -> Bool {
    let key = namespaced(key)
    if UserDefaults.standard.dictionaryRepresentation().keys.contains(key),
      let _ = UserDefaults.standard.object(forKey: key) {
      return true
    } else {
      return false
    }
  }
  
}

// MARK: - UserDefaults のキー定義

struct Defaults : StringDefaultSettable {

  enum StringKey : String {
    case AdvertisementName
  }

}

//
//  UserDefaults+.swift
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

protocol StringDefaultSettable : KeyNamespaceable {
  associatedtype StringKey : RawRepresentable
}

// MARK: - 文字列値のためのプロトコル拡張実装
extension StringDefaultSettable where StringKey.RawValue == String {
  
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

protocol BoolDefaultSettable : KeyNamespaceable {
  associatedtype BoolKey : RawRepresentable
}

// MARK: - Bool値のためのプロトコル拡張実装
extension BoolDefaultSettable where BoolKey.RawValue == String {
  
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

protocol IntegerDefaultSettable : KeyNamespaceable {
  associatedtype IntegerKey : RawRepresentable
}

// MARK: - Integer値のためのプロトコル拡張実装
extension IntegerDefaultSettable where IntegerKey.RawValue == String {
  
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

protocol ObjectDefaultSettable : KeyNamespaceable {
  associatedtype ObjectKey : RawRepresentable
}

// MARK: - Object値のためのプロトコル拡張実装
extension ObjectDefaultSettable where ObjectKey.RawValue == String {
  
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

struct Defaults : StringDefaultSettable {

  enum StringKey : String {
    case AdvertisementName
  }

}

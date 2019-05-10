//
//  AppError.swift
//  sample-ios-ble
//
//  Created by 金子実 on 2019/05/10.
//  Copyright © 2019 quiet branch studio. All rights reserved.
//

import Foundation

enum AppError: Error {

  enum Level {
    case api
    case fatal
    case warning
    case ignore
    case unknown
  }
  
  enum Reason: Int, CustomStringConvertible, Equatable {

    case unexpected = 15
    case internalAppError = 16
    case unknown = 20
    
    public var description: String {
      get {
        switch self {
        case .unexpected:
          return "予期せぬエラーが発生しました"
        case .internalAppError:
          return "アプリの内部エラーが発生しました"
        case .unknown:
          return "不明なエラーが発生しました"
        }
      }
    }
    
    public static func == (lhs: Reason, rhs: Reason) -> Bool {
      return lhs.rawValue == rhs.rawValue
    }

  }
  
  case error(level: Level, reason: Reason, title: String?, description: String)
  
}

extension AppError: CustomStringConvertible {
  
  public var description: String {
    get {
      guard case let .error(_, _, _, description) = self else {
        return ""
      }
      return description
    }
  }
  
}

protocol AppErrorAssociatedValue {
  
  var level: AppError.Level { get }
  var reason: AppError.Reason { get }
  var title: String? { get }
  
}

extension AppError: AppErrorAssociatedValue {
  
  var level: AppError.Level {
    get {
      guard case let .error(level, _, _, _) = self else {
        return .unknown
      }
      return level
    }
  }
  
  var reason: AppError.Reason {
    get {
      guard case let .error(_, reason, _, _) = self else {
        return .unknown
      }
      return reason
    }
  }
  
  var title: String? {
    get {
      guard case let .error(_, _, title, _) = self else {
        return nil
      }
      return title
    }
  }
  
}

extension AppError: LocalizedError {
  
  var localizedDescription: String {
    get {
      return String(describing: self)
    }
  }
  
  public var errorDescription: String? {
    get {
      return localizedDescription
    }
  }
  
  public var failureReason: String? {
    get {
      guard case let .error(_, reason, _, _) = self else {
        return nil
      }
      return String(describing: reason)
    }
  }
  
}

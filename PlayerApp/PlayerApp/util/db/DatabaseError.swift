//
//  DatabaseError.swift
//  PlayerApp
//
//  Created by IOS-Cakra on 06/09/26.
//
import Foundation

public enum DatabaseError: LocalizedError {
  case invalidInstance
  case requestFailed
  case entityEmpty

  public var errorDescription: String? {
    switch self {
    case .invalidInstance: return "DB1#Database can't instance."
    case .requestFailed: return "DB2#Your request failed."
    case .entityEmpty: return "DB3#Your entitiy is empty"
    }
  }
}

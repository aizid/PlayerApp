//
//  CoreRealm.swift
//  PlayerApp
//
//  Created by IOS-Cakra on 06/09/26.
//
import Foundation
import RealmSwift

extension Realm {
  public func safeWrite(_ block: (() throws -> Void)) throws {
    if isInWriteTransaction {
      try block()
    } else {
      try write(block)
    }
  }
}


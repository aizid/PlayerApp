//
//  ErrorResponse.swift
//  PlayerApp
//
//  Created by IOS-Cakra on 06/09/26.
//

public struct ErrorResponse: Codable {
  public let timestamp: ValueWrapper?
  public let status: ValueWrapper?
  public let error, exception, message, title, description, detail, path: String?
}

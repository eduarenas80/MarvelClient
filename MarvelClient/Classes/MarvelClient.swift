//
//  MarvelClient.swift
//  Pods
//
//  Created by Eduardo Arenas on 5/6/16.
//
//

import Foundation
import Alamofire

public class MarvelClient {
  
  let privateKey: String
  let publicKey: String
  
  public init(privateKey: String, publicKey: String) {
    self.privateKey = privateKey
    self.publicKey = publicKey
  }
  
  public func requestCharacters() -> CharacterRequestBuilder {
    return CharacterRequestBuilder(privateKey: self.privateKey, publicKey: self.publicKey)
  }
}
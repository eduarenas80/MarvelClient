//
//  RequestBuilder.swift
//  Pods
//
//  Created by Eduardo Arenas on 5/6/16.
//
//

import Foundation
import Alamofire
import SwiftyJSON

public typealias MarvelResultsFilter = (entityTipe: String, id: String)

public class MarvelRequestBuilder {
  
  private let baseEndpoint = "https://gateway.marvel.com/v1/public/"
  private let keys: MarvelAPIKeys
  
  public let entityType: String
  public var resultsFilter: MarvelResultsFilter?
  public var modifiedSince: NSDate?
  public var resultsLimit: Int?
  public var resultsOffset: Int?
  
  var request: Request {
    return Alamofire.request(.GET, self.url, parameters: self.parameters, encoding: .URL)
  }
  
  var parameters: [String: AnyObject] {
    return buildAuthenticationParameters() + buildQueryParameters()
  }
  
  var url: String {
    if let filter = self.resultsFilter {
      return "\(self.baseEndpoint)\(filter.entityTipe)/\(filter.id)/\(self.entityType)"
    } else {
      return "\(self.baseEndpoint)\(self.entityType)"
    }
  }
  
  init(entityType: String, keys: MarvelAPIKeys) {
    self.entityType = entityType
    self.keys = keys
  }
  
  public func modifiedSince(modifiedSince: NSDate) -> Self {
    self.modifiedSince = modifiedSince
    return self
  }
  
  public func filter(resultsFilter: MarvelResultsFilter) -> Self {
    self.resultsFilter = resultsFilter
    return self
  }
  
  public func limit(resultsLimit: Int) -> Self {
    self.resultsLimit = resultsLimit
    return self
  }
  
  public func offset(resultsOffset: Int) -> Self {
    self.resultsOffset = resultsOffset
    return self
  }
  
  func fetchResults<T: Entity>(completionHandler: Wrapper<T> -> Void) {
    self.request.responseJSON { (response) in
      switch response.result {
      case .Success:
        if let value = response.result.value {
          let result = Wrapper<T>(json: JSON(value))
          completionHandler(result)
        }
      case .Failure(let error):
        print(error)
      }
    }
  }
  
  func buildQueryParameters() -> [String: AnyObject] {
    var queryParameters = [String: AnyObject]()
    
    if let modifiedSince = self.modifiedSince {
      queryParameters["modifiedSince"] = modifiedSince.marvelDateTimeString
    }
    if let limit = self.resultsLimit {
      queryParameters["limit"] = String(limit)
    }
    if let offset = self.resultsOffset {
      queryParameters["offset"] = String(offset)
    }
    
    return queryParameters
  }
  
  private func buildAuthenticationParameters() -> [String: String] {
    let timestamp = NSDate().timeIntervalSince1970
    let requestHash = "\(timestamp)\(self.keys.privateKey)\(self.keys.publicKey)".md5Hash
    return ["ts": "\(timestamp)",
            "apikey": self.keys.publicKey,
            "hash": requestHash]
    
  }
}

public struct DateRange: CustomStringConvertible {
  
  let startDate: NSDate
  let endDate: NSDate
  
  public var description: String {
    return "\(self.startDate.marvelDateString),\(self.endDate.marvelDateString)"
  }
}

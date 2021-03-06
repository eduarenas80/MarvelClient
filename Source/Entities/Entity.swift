//
//  Entity.swift
//  MarvelClient
//
//  Copyright (c) 2016 Eduardo Arenas <eapdev@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import SwiftyJSON

public protocol JSONSerializable {
  init(json: JSON)
}

public protocol Entity: JSONSerializable {
  var id: Int { get }
  var modified: NSDate? { get }
  var resourceURI: String { get }
  var thumbnail: Image { get }
}

public protocol EntitySummary: JSONSerializable {
  var resourceURI: String { get }
  var name: String { get }
  var id: Int? { get }
}

public extension EntitySummary {
  var id: Int? {
    guard let url = NSURL(string: self.resourceURI) else {
      return nil
    }
    guard let pathComponents = url.pathComponents else {
      return nil
    }
    return Int(pathComponents.last!)
  }
}

public enum EntityType: String {
  case Characters = "characters"
  case Comics = "comics"
  case Creators = "creators"
  case Events = "events"
  case Series = "series"
  case Stories = "stories"
}

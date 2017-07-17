//
//  Episode.swift
//  GotEpisodes
//
//  Created by Fabio Butti on 13/07/17.
//  Copyright © 2017 tiknil. All rights reserved.
//

import Foundation
import ObjectMapper
import Timepiece

public class Episode : Mappable, CustomStringConvertible {
  var id: Int?
  
  var title: String?
  var season: Int?
  var number: Int?
  var airDate: Date?
  var summary: String?
  var imageUrl: String?
  
  // MARK: Mappable
  public required init?(map: Map) {
    
  }
  
  public func mapping(map: Map) {
    id                <- map["id"]
    title             <- map["name"]
    season            <- map["season"]
    number            <- map["number"]
    airDate           <- (map["airDate"], ApiDateTransformer())
    summary           <- map["summary"]
    imageUrl          <- map["image.medium"]
  }
  
  public var description: String {
    return title ?? ""
  }
}

public class ApiDateTransformer : TransformType {
  public typealias Object = Date
  public typealias JSON = String
  public let dateFormat = "yyyy-MM-dd"
  
  public func transformFromJSON(_ value: Any?) -> Date? {
    if let dateString = value as? String {
      return dateString.date(inFormat: dateFormat)
    }
    return nil
  }
  
  public func transformToJSON(_ value: Date?) -> String? {
    guard let date = value else {
      return nil
    }
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormat
    return dateFormatter.string(from: date)
  }
}

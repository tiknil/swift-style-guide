//
//  Episode.swift
//  GotEpisodes
//
//  Created by Fabio Butti on 13/07/17.
//  Copyright © 2017 tiknil. All rights reserved.
//

import Foundation
import Timepiece

public class Episode : Codable {
  struct Image: Codable {
    let mediumUrl: URL?
    let originalUrl: URL?
    
    enum CodingKeys : String, CodingKey {
      case mediumUrl = "medium"
      case originalUrl = "original"
    }
  }
  
  // MARK: - Properties
  var id: Int
  var title: String
  var season: Int
  var number: Int
  var airDate: Date
  var summary: String
  var image: Image
  
  enum CodingKeys : String, CodingKey {
    case id
    case title = "name"
    case season
    case number
    case airDate = "airstamp"
    case summary
    case image
  }
}

extension Episode: CustomStringConvertible {
  public var description: String {
    return title
  }
}

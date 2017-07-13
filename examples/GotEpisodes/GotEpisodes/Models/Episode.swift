//
//  Episode.swift
//  GotEpisodes
//
//  Created by Fabio Butti on 13/07/17.
//  Copyright © 2017 tiknil. All rights reserved.
//

import Himotoki
import Timepiece

public struct Episode {
  let id: String
  
  let director: String
  let airDate: Date
  let totalNumber: Int
  let seasonNumber: Int
  let number: Int
  let title: String
  let characters: [String]
}

// MARK: Decodable
extension Episode: Decodable {
  public static func decode(_ e: Extractor) throws -> Episode {
    let DateTransformer = Transformer<String, Date> { DateString throws -> Date in
      if let date = DateString.date(inFormat: "yyyy-MM-ddTHH:mm:ss.SSSZ") {
        return date
      }
      
      throw customError("Invalid Date string: \(DateString)")
    }
    
    return try Episode(
      id: e <| "_id",
      director: e <| "director",
      airDate: try DateTransformer.apply(e <| "airDate"),
      totalNumber: e <| "totalNr",
      seasonNumber: e <| "season",
      number: e <| "nr",
      title: e <| "name",
      characters: e <|| "characters")
  }
}

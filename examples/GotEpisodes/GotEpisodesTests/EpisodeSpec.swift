//
//  EpisodeSpec.swift
//  GotEpisodes
//
//  Created by Fabio Butti on 18/07/17.
//  Copyright © 2017 tiknil. All rights reserved.
//

import Quick
import Nimble
import Timepiece
@testable import GotEpisodes

class EpisodeSpec: QuickSpec {
  override func spec() {
    it("correctly parsed from json") {
      // Arrange: inizializzo il json
      let jsonEpisode = "{\"id\":1,\"name\":\"Title\",\"season\":1,\"number\":1,\"airdate\":\"2017-07-18\",\"image\":{\"medium\":\"http://static.tvmaze.com/uploads/images/medium_landscape/1/2668.jpg\",\"original\":\"http://static.tvmaze.com/uploads/images/original_untouched/1/2668.jpg\"},\"summary\":\"<p>Episode description</p>\"}"
      
      // Act: parso il json nell'oggetto Episode
      let episode = Mapper<Episode>().map(JSONString: jsonEpisode)
      
      // Assert: controllo che l'oggetto creato abbia i valori presenti nel json
      expect(episode?.id).to(equal(1))
      expect(episode?.title).to(equal("Title"))
      expect(episode?.season).to(equal(1))
      expect(episode?.number).to(equal(1))
      expect(episode?.airDate?.year).to(equal(2017))
      expect(episode?.airDate?.month).to(equal(7))
      expect(episode?.airDate?.day).to(equal(18))
      expect(episode?.imageUrl).to(equal("http://static.tvmaze.com/uploads/images/medium_landscape/1/2668.jpg"))
      expect(episode?.summary).to(equal("<p>Episode description</p>"))
    }
  }
}

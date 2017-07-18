//
//  EpisodeCellViewModelSpec.swift
//  GotEpisodes
//
//  Created by Fabio Butti on 18/07/17.
//  Copyright © 2017 tiknil. All rights reserved.
//

import Quick
import Nimble
import Timepiece
import ReactiveCocoa
import ReactiveSwift
@testable import GotEpisodes

class EpisodeCellViewModelSpec: QuickSpec {
  override func spec() {
    var viewmodel: EpisodeCellViewModel!
    let stubEpisode = Episode()
    beforeEach {
      stubEpisode.title = "Title"
      stubEpisode.season = 1
      stubEpisode.number = 1
      stubEpisode.airDate = Date(year: 2017, month: 7, day: 18)
      
      viewmodel = EpisodeCellViewModel(episode: stubEpisode)
    }
    
    it("setup properties correctly") {
      // Assert: controllo che le properties contengano valori coerenti con l'episode stub
      expect(viewmodel.titleText.value).to(equal("Title"))
      expect(viewmodel.seasonText.value).to(equal("Season: 1"))
      expect(viewmodel.numberText.value).to(equal("Episode: 1"))
      expect(viewmodel.airDateText.value).to(equal("Air date: 18/07/17"))
    }
  }
}

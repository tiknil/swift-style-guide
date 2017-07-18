//
//  EpisodesViewModelSpec.swift
//  GotEpisodes
//
//  Created by Fabio Butti on 18/07/17.
//  Copyright © 2017 tiknil. All rights reserved.
//

import Quick
import Nimble
import ReactiveCocoa
import ReactiveSwift
@testable import GotEpisodes

class EpisodesViewModelSpec: QuickSpec {
  // MARK: Stub
  class StubApiService: ApiServiceProtocol {
    func getEpisodes() -> SignalProducer<[Episode], NetworkError> {
      return SignalProducer<[Episode], NetworkError> { observer, disposable in
        observer.send(value: [Episode(), Episode()])
        observer.sendCompleted()
      }
    }
  }
  
  // MARK: Spec
  override func spec() {
    var viewmodel: EpisodesViewModel!
    beforeEach {
      viewmodel = EpisodesViewModel(apiService: StubApiService())
    }
    
    describe("update episodes") {
      it("should set episodesVm") {
        // Act: avvio l'update degli episodi
        viewmodel.updateEpisodes()
        
        // Assert: controllo che la lista abbia lo stesso numero di elementi fornito dallo stub
        expect(viewmodel.episodesVm.value.count).toEventually(equal(2))
      }
    }
  }
}

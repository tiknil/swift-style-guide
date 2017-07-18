//
//  ContainerSpec.swift
//  GotEpisodes
//
//  Created by Fabio Butti on 18/07/17.
//  Copyright © 2017 tiknil. All rights reserved.
//

import Quick
import Nimble
import Swinject
@testable import GotEpisodes

class ContainerSpec: QuickSpec {
  override func spec() {
    var container: Container!
    beforeEach {
      container = AppDelegate.container
    }
    
    describe("Container") {
      it("Resolve every service") {
        let episode = Episode()
        
        //************* MODELS *************//
        expect(container.resolve(ApiServiceProtocol.self)).notTo(beNil())
        
        //************* VIEWMODELS *************//
        expect(container.resolve(EpisodesViewModel.self)).notTo(beNil())
        expect(container.resolve(EpisodeDetailViewModel.self, argument: episode)).notTo(beNil())
        
        //************* VIEWS *************//
        expect(container.resolve(EpisodesTableViewController.self)).notTo(beNil())
        expect(container.resolve(EpisodeDetailViewController.self, argument: episode)).notTo(beNil())
      }
      
      it("Injects viewmodels to views") {
        // Arrange: risoluzione delle view
        let episodes = container.resolve(EpisodesTableViewController.self)
        let episodeDetail = container.resolve(EpisodeDetailViewController.self, argument: Episode())
        
        // Assert: controllo che i viewmodels siano presenti
        expect(episodes?.viewModel).notTo(beNil())
        expect(episodeDetail?.viewModel).notTo(beNil())
      }
    }
  }
}

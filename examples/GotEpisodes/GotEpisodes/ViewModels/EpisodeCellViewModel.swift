//
//  EpisodeCellViewModel.swift
//  GotEpisodes
//
//  Created by Fabio Butti on 18/07/17.
//  Copyright © 2017 tiknil. All rights reserved.
//

import ReactiveCocoa
import ReactiveSwift

/**
 Nel caso di ViewModel legati a UIView possiamo evitare di ereditare da TkMvvmViewModel perché i metodi utili sono legati solo agli stati di caricamento del ViewController
 */
class EpisodeCellViewModel {
  
  // MARK: - Properties
  // MARK: Class
  
  
  // MARK: Public
  
  let episode: Episode
  let titleText = MutableProperty("")
  let seasonText = MutableProperty("Season: -")
  let numberText = MutableProperty("Episode: -")
  let airDateText = MutableProperty("Air date: -")
  
  
  // MARK: Private
  
  
  // MARK: - Methods
  // MARK: Class
  
  
  // MARK: Lifecycle
  
  init(episode: Episode) {
    self.episode = episode
    // Assegnazione alle property dei valori recuperati dal model Episode
    titleText.value = episode.title ?? ""
    let seasonString = (episode.season != nil) ? String(describing: episode.season!) : "-"
    seasonText.value = "Season: \(seasonString)"
    let numberString = (episode.number != nil) ? String(describing: episode.number!) : "-"
    numberText.value = "Episode: \(numberString)"
    let airDateString = (episode.airDate != nil) ? episode.airDate!.dateString(in: .short) : "-"
    airDateText.value = "Air date: \(airDateString)"
  }
  
  
  // MARK: Custom accessors
  
  
  // MARK: IBActions
  
  
  // MARK: Public
  
  
  // MARK: Private
  
  
  
}

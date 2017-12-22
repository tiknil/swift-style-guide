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
  let imageUrl: MutableProperty<URL?> = MutableProperty(nil)
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
    imageUrl.value = episode.image.mediumUrl
    titleText.value = episode.title
    seasonText.value = "Season: \(String(describing: episode.season))"
    numberText.value = "Episode: \(String(describing: episode.number))"
    airDateText.value = "Air date: \(episode.airDate.stringIn(dateStyle: .short, timeStyle: .short))"
  }
  
  
  // MARK: Custom accessors
  
  
  // MARK: IBActions
  
  
  // MARK: Public
  
  
  // MARK: Private
  
  
  
}

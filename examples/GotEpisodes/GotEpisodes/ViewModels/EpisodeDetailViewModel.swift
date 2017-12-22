//
//  EpisodeDetailViewModel.swift
//  GotEpisodes
//
//  Created by Fabio Butti on 18/07/17.
//  Copyright © 2017 tiknil. All rights reserved.
//

import ReactiveCocoa
import ReactiveSwift

class EpisodeDetailViewModel: BaseViewModel {
  
  // MARK: - Properties
  // MARK: Class
  
  
  // MARK: Public
  
  let imageUrl: MutableProperty<URL?> = MutableProperty(nil)
  let titleText = MutableProperty("")
  let seasonText = MutableProperty("")
  let numberText = MutableProperty("")
  let airDateText = MutableProperty("")
  let summaryText = MutableProperty("")
  
  
  // MARK: Private
  
  
  // MARK: - Methods
  // MARK: Class
  
  
  // MARK: Lifecycle
  
  public init(apiService: ApiServiceProtocol, episode: Episode) {
    super.init(apiService: apiService)
    
    imageUrl.value = episode.image.originalUrl
    titleText.value = episode.title
    seasonText.value = String(describing: episode.season)
    numberText.value = String(describing: episode.number)
    airDateText.value = episode.airDate.stringIn(dateStyle: .short, timeStyle: .short)
    summaryText.value = episode.summary.replacingOccurrences(of: "<p>", with: "").replacingOccurrences(of: "</p>", with: "")
  }
  
  
  // MARK: Custom accessors
  
  
  // MARK: IBActions
  
  
  // MARK: Public
  
  
  // MARK: Private
  
  
}

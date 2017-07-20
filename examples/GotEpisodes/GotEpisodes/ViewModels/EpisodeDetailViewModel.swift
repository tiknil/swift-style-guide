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
  
  let imageUrl = MutableProperty("")
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
    
    imageUrl.value = episode.imageUrl ?? ""
    titleText.value = episode.title ?? ""
    seasonText.value = (episode.season != nil) ? String(describing: episode.season!) : "-"
    numberText.value = (episode.number != nil) ? String(describing: episode.number!) : "-"
    airDateText.value = episode.airDate?.dateString(in: .short) ?? "-"
    summaryText.value = episode.summary?.replacingOccurrences(of: "<p>", with: "").replacingOccurrences(of: "</p>", with: "") ?? "-"
  }
  
  
  // MARK: Custom accessors
  
  
  // MARK: IBActions
  
  
  // MARK: Public
  
  
  // MARK: Private
  
  
}

//
//  EpisodeTableViewCell.swift
//  GotEpisodes
//
//  Created by Fabio Butti on 17/07/17.
//  Copyright © 2017 tiknil. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class EpisodeTableViewCell: UITableViewCell {

  // MARK: - Properties
  // MARK: Class
  
  
  // MARK: Public
  
  @IBOutlet weak var artwork: UIImageView!
  @IBOutlet weak var title: UILabel!
  @IBOutlet weak var season: UILabel!
  @IBOutlet weak var number: UILabel!
  @IBOutlet weak var airDate: UILabel!
  
  var viewModel: EpisodeCellViewModel? {
    didSet {
      // Impostazione dei bind all'assegnazione del viewmodel
      if let vm = viewModel {
        title.reactive.text <~ vm.titleText
        season.reactive.text <~ vm.seasonText
        number.reactive.text <~ vm.numberText
        airDate.reactive.text <~ vm.airDateText
      }
    }
  }
  
  // MARK: Private
  
  
  // MARK: - Methods
  // MARK: Class
  
  
  // MARK: Lifecycle
  
  
  // MARK: Custom accessors
  
  
  // MARK: IBActions
  
  
  // MARK: Public
  
  
  // MARK: Private
  
  

}

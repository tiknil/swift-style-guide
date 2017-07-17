//
//  EpisodesViewModel.swift
//  GotEpisodes
//
//  Created by Fabio Butti on 17/07/17.
//  Copyright © 2017 tiknil. All rights reserved.
//

import ReactiveSwift
import ReactiveCocoa

public class EpisodesViewModel: NSObject {
  
  // MARK: - Properties
  // MARK: Class
  
  
  // MARK: Public
  
  var episodes: [Episode] = [] {
    didSet {
      viewController.tableView.reloadData()
    }
  }
  
  
  // MARK: Private
  
  private let apiService: ApiServiceProtocol
  private let viewController: EpisodesTableViewController
  
  
  // MARK: - Methods
  // MARK: Class
  
  
  // MARK: Lifecycle
  
  public init(viewController: EpisodesTableViewController, apiService: ApiServiceProtocol) {
    self.viewController = viewController
    self.apiService = apiService
  }
  
  
  // MARK: Custom accessors
  
  
  // MARK: IBActions
  
  
  // MARK: Public
  
  public func updateEpisodes() {
    let api = ApiService(with: .development)
    api.getEpisodes().startWithResult { response in
      guard let episodes = response.value else {
        print("Error: \(response.error!)")
        return
      }
      
      print("Episodes: \(episodes)")
      self.episodes = episodes
    }
  }
  
  
  // MARK: Private
  
  
}

// MARK: UITableViewDelegate, UITableViewDataSource
extension EpisodesViewModel : UITableViewDelegate, UITableViewDataSource {
  
  public func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return episodes.count
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeCell", for: indexPath) as! EpisodeTableViewCell
    
    //TODO: sarebbe da rendere più MVVM friendly tramite bindings
    let episode = episodes[indexPath.row]
    cell.title.text = episode.title
    if let season = episode.season { cell.season.text = "Season: \(String(describing: season))" } else { cell.season.text = "Season: -" }
    if let number = episode.number { cell.number.text = "Episode: \(String(describing: number))" } else { cell.number.text = "Episode: -" }
    if let airDate = episode.airDate { cell.airDate.text = "Air date: \(String(describing: airDate))" } else { cell.airDate.text = "Air date: -" }
    if let summary = episode.summary { cell.summary.text = "Summary: \(String(describing: summary))" } else { cell.summary.text = "Summary: -" }
    
    return cell
  }
  
}

//
//  EpisodesViewModel.swift
//  GotEpisodes
//
//  Created by Fabio Butti on 17/07/17.
//  Copyright © 2017 tiknil. All rights reserved.
//

import ReactiveSwift
import ReactiveCocoa
import Swinject

// Questo viewmodel è un NSObject perché è necessario per implementare i protocolli UITableViewDelegate, UITableViewDataSource
public class EpisodesViewModel: NSObject {
  
  // MARK: - Properties
  // MARK: Class
  
  
  // MARK: Public
  
  let episodesVm: MutableProperty<[EpisodeCellViewModel]> = MutableProperty([])
  
  
  // MARK: Private
  
  private let apiService: ApiServiceProtocol
  
  
  // MARK: - Methods
  // MARK: Class
  
  
  // MARK: Lifecycle
  
  public init(apiService: ApiServiceProtocol) {
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
      
      // Aggiorno la property degli episodi
      self.episodesVm.value = episodes.map({ (episode) -> EpisodeCellViewModel in
        // La property contiene direttamente i viewmodel, quindi eseguo il mapping Episode -> EpisodeCellViewModel
        return EpisodeCellViewModel(episode: episode)
      })
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
    return episodesVm.value.count
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeCell", for: indexPath) as! EpisodeTableViewCell
    
    // Bind tra cella e suo viewmodel
    let episodeVm = episodesVm.value[indexPath.row]
    cell.viewModel = episodeVm
    
    return cell
  }
  
  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // Utilizzo del router per visualizzare la schermata di dettaglio
    let episodeVm = episodesVm.value[indexPath.row]
    AppDelegate.router?.pushRoutableView(view: .episodeDetail, animated: true, with: episodeVm.episode)
  }
  
}

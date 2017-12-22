//
//  EpisodesTableViewController.swift
//  GotEpisodes
//
//  Created by Fabio Butti on 13/07/17.
//  Copyright © 2017 tiknil. All rights reserved.
//

import UIKit

class EpisodesTableViewController: TkMvvmTableViewController<EpisodesViewModel> {

  // MARK: - Properties
  // MARK: Class
  
  
  // MARK: Public
  
  
  // MARK: Private
  
  
  // MARK: - Methods
  // MARK: Class
  
  
  // MARK: Lifecycle
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    // Impostazione navigation bar
    tabBarItem = UITabBarItem(title: "Episodes", image: UIImage(named: "list"), tag: 0)
    navigationItem.title = "Episodes"
    
    // Aggiornamento lista episodi da ViewModel
    viewModel?.updateEpisodes()
    
    title = "GoT episodes"
  }
  
  override func setupBindings() {
    super.setupBindings()
    
    if let vm = viewModel {
      // Assegnazione dei delegate della tableview al viewmodel
      tableView.delegate = vm
      tableView.dataSource = vm
      // Observe dell'aggiornamento degli episodi
      vm.episodesVm.signal.observeValues({ (episodesVm2) in
        DispatchQueue.main.async {
          self.tableView.reloadData()
        }
      })
    }
  }
  
  // MARK: Custom accessors
  
  
  // MARK: IBActions
  
  
  // MARK: Public
  
  
  // MARK: Private
  
  

}

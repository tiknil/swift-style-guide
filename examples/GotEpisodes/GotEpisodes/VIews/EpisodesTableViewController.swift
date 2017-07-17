//
//  EpisodesTableViewController.swift
//  GotEpisodes
//
//  Created by Fabio Butti on 13/07/17.
//  Copyright © 2017 tiknil. All rights reserved.
//

import UIKit

public class EpisodesTableViewController: UITableViewController {

  // MARK: - Properties
  // MARK: Class
  
  
  // MARK: Public
  
  public var viewModel: EpisodesViewModel? {
    didSet {
      tableView.delegate = viewModel
      tableView.dataSource = viewModel
      viewModel?.updateEpisodes()
    }
  }
  
  
  // MARK: Private
  
  
  // MARK: - Methods
  // MARK: Class
  
  
  // MARK: Lifecycle
  
  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    print("DIDAPPEAR")
    tableView.reloadData()
  }
  
  // MARK: Custom accessors
  
  
  // MARK: IBActions
  
  
  // MARK: Public
  
  
  // MARK: Private
  
  

}

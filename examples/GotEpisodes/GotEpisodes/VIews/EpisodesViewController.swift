//
//  EpisodesViewController.swift
//  GotEpisodes
//
//  Created by Fabio Butti on 13/07/17.
//  Copyright © 2017 tiknil. All rights reserved.
//

import UIKit

class EpisodesViewController: UIViewController {

  // MARK: - Properties
  // MARK: Class
  
  
  // MARK: Public
  
  
  // MARK: Private
  
  
  // MARK: - Methods
  // MARK: Class
  
  
  // MARK: Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let api = ApiService(with: .development)
    api.getEpisodes(success: { (episodes) in
      print("SUCCESS: \(episodes)")
    }) { (e) in
      print("ERROR \(e)")
    }
  }
  
  
  // MARK: Custom accessors
  
  
  // MARK: IBActions
  
  
  // MARK: Public
  
  
  // MARK: Private
  
  

}

//
//  Router.swift
//  GotEpisodes
//
//  Created by Fabio Butti on 18/07/17.
//  Copyright © 2017 tiknil. All rights reserved.
//

import UIKit
import Swinject

enum RoutableView {
  case episodes
  case episodeDetail
}

final class Router {
  
  // MARK: - Properties
  // MARK: Class

  
  // MARK: Public
  
  var currentView: UIViewController?
  var currentViewModel: Any?
  
  
  // MARK: Private
  
  private let navigationController: UINavigationController
  
  
  // MARK: - Methods
  // MARK: Class
  
  
  // MARK: Lifecycle
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
    currentView = navigationController.topViewController
  }
  
  
  // MARK: Custom accessors
  
  
  // MARK: IBActions
  
  
  // MARK: Public
  
  public func pushRoutableView(view: RoutableView, animated: Bool, with data: Any? = nil) {
    currentView = viewForRoutableView(routableView: view, with: data)
    navigationController.pushViewController(currentView!, animated: animated)
  }
  
  public func popRoutableView(view: RoutableView, animated: Bool) {
    navigationController.popViewController(animated: animated)
    currentView = navigationController.topViewController
  }
  
  public func presentRoutableView(view: RoutableView, animated: Bool, with data: Any? = nil) {
    currentView = viewForRoutableView(routableView: view, with: data)
    navigationController.present(currentView!, animated: animated, completion: nil)
  }
  
  public func dismissRoutableView(view: RoutableView, animated: Bool) {
    currentView?.dismiss(animated: animated, completion: nil)
  }
  
  
  // MARK: Private
  
  private func viewForRoutableView(routableView: RoutableView, with data: Any? = nil) -> UIViewController {
    switch routableView {
    case .episodes:
      return AppDelegate.container.resolve(EpisodesTableViewController.self)!
    case .episodeDetail:
      return AppDelegate.container.resolve(EpisodeDetailViewController.self, argument: data as! Episode)!
    }
  }
  
}

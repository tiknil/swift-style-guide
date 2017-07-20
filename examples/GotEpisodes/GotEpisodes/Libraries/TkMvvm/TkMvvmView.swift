//
//  TkMvvmViewController.swift
//
//  Created by Fabio Butti on 19/07/17.
//  Copyright © 2017 Tiknil. All rights reserved.
//

import UIKit

protocol TkMvvmViewProtocol {
  associatedtype VM
  
  var viewModel: VM? { get set }
  
  func setupBindings()
}

class TkMvvmView<T: AnyObject>: UIView, TkMvvmViewProtocol {
  typealias VM = T
  
  // MARK: - Properties
  // MARK: Public
  
  var viewModel: VM? {
    didSet {
      if viewModel != nil {
        setupBindings()
      }
    }
  }
  
  // MARK: - Methods
  
  // MARK: Private
  
  internal func setupBindings() {
    // Va eseguito l'override nelle classi figlie
  }

}

class TkMvvmViewController<T: TkMvvmViewModel>: UIViewController, TkMvvmViewProtocol {
  typealias VM = T
  
  // MARK: - Properties
  // MARK: Class
  
  
  // MARK: Public
  
  var viewModel: VM? {
    didSet {
      if viewModel != nil && isViewLoaded {
        setupBindings()
      }
    }
  }
  
  // MARK: Private
  
  
  // MARK: - Methods
  // MARK: Class
  
  
  // MARK: Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel?.viewDidLoad()
    if viewModel != nil && isViewLoaded {
      setupBindings()
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewModel?.viewWillAppear()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    viewModel?.viewDidAppear()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    viewModel?.viewWillDisappear()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    viewModel?.viewDidDisappear()
  }
  
  
  // MARK: Custom accessors
  
  
  // MARK: IBActions
  
  
  // MARK: Public
  
  public static func instantiateFrom(storyboardWithName name: String, and identifier: String? = nil) -> TkMvvmViewController<VM> {
    let sb = UIStoryboard(name: name, bundle: Bundle(for: self))
    if let id = identifier {
      return sb.instantiateViewController(withIdentifier: id) as! TkMvvmViewController<VM>
    } else {
      let defaultId = String(describing: self)
      return sb.instantiateViewController(withIdentifier: defaultId) as! TkMvvmViewController<VM>
    }
  }
  
  // MARK: Private
  
  internal func setupBindings() {
    // Va eseguito l'override nelle classi figlie
  }
  
  
}

class TkMvvmTableViewController<T: TkMvvmViewModel>: UITableViewController, TkMvvmViewProtocol {
  typealias VM = T
  
  // MARK: - Properties
  // MARK: Class
  
  
  // MARK: Public
  
  var viewModel: VM? {
    didSet {
      if viewModel != nil && isViewLoaded {
        setupBindings()
      }
    }
  }
  
  // MARK: Private
  
  
  // MARK: - Methods
  // MARK: Class
  
  
  // MARK: Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel?.viewDidLoad()
    if viewModel != nil && isViewLoaded {
      setupBindings()
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewModel?.viewWillAppear()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    viewModel?.viewDidAppear()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    viewModel?.viewWillDisappear()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    viewModel?.viewDidDisappear()
  }
  
  
  // MARK: Custom accessors
  
  
  // MARK: IBActions
  
  
  // MARK: Public
  
  public static func instantiateFrom(storyboardWithName name: String, and identifier: String? = nil) -> TkMvvmTableViewController<VM> {
    let sb = UIStoryboard(name: name, bundle: Bundle(for: self))
    if let id = identifier {
      return sb.instantiateViewController(withIdentifier: id) as! TkMvvmTableViewController<VM>
    } else {
      let defaultId = String(describing: self)
      return sb.instantiateViewController(withIdentifier: defaultId) as! TkMvvmTableViewController<VM>
    }
  }
  
  // MARK: Private
  
  internal func setupBindings() {
    // Va eseguito l'override nelle classi figlie
  }
  
  
}

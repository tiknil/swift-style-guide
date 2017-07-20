//
//  TkMvvmRouter.swift
//  OnReal
//
//  Created by Fabio Butti on 19/07/17.
//  Copyright © 2017 OnReal. All rights reserved.
//

import Swinject

protocol TkMvvmRouterProtocol {
  var navigationController: UINavigationController { get }
  var currentView: UIViewController? { get }
  
  func pushView<C>(view: C.Type, animated: Bool, with data: Any?)
  func popView<C>(view: C.Type, animated: Bool)
  func presentView<C>(view: C.Type, animated: Bool, with data: Any?)
  func dismissView<C>(view: C.Type, animated: Bool)
}

final class TkMvvmRouter: TkMvvmRouterProtocol {
  
  // MARK: - Properties
  // MARK: Class
  
  
  // MARK: Public
  
  let navigationController: UINavigationController
  var currentView: UIViewController?
  
  
  // MARK: Private
  
  internal let container: Swinject.Container
  
  
  // MARK: - Methods
  // MARK: Class
  
  
  // MARK: Lifecycle
  
  init(navigationController: UINavigationController, container: Swinject.Container) {
    self.navigationController = navigationController
    currentView = navigationController.topViewController
    self.container = container
  }
  
  
  // MARK: Custom accessors
  
  
  // MARK: IBActions
  
  
  // MARK: Public
  
  public func pushView<C>(view: C.Type, animated: Bool, with data: Any?) {
    currentView = viewForType(type: view, with: data) as? UIViewController
    if let v = currentView {
      navigationController.pushViewController(v, animated: animated)
    } else {
      fatalError("Container cannot resolve type \(C.self)")
    }
  }
  
  public func popView<C>(view: C.Type, animated: Bool) {
    navigationController.popViewController(animated: animated)
    currentView = navigationController.topViewController
  }
  
  public func presentView<C>(view: C.Type, animated: Bool, with data: Any?) {
    currentView = viewForType(type: view, with: data) as? UIViewController
    if let v = currentView {
      navigationController.present(v, animated: animated, completion: nil)
    } else {
      fatalError("Container cannot resolve type \(C.self)")
    }
  }
  
  public func dismissView<C>(view: C.Type, animated: Bool) {
    currentView?.dismiss(animated: animated, completion: nil)
  }
  
  
  // MARK: Private
  
  private func viewForType<C>(type: C.Type, with data: Any? = nil) -> C? {
    return (data != nil) ? container.resolve(type, argument: data) : container.resolve(type)
  }

}

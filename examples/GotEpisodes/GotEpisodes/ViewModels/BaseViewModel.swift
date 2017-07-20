//
//  BaseViewModel.swift
//  GotEpisodes
//
//  Created by Fabio Butti on 20/07/17.
//  Copyright © 2017 tiknil. All rights reserved.
//

import Foundation

/**
 Creiamo sempre una classe BaseViewModel figlia di TkMvvmViewModel da utilizzare come padre di ogni ViewModel dei ViewController (schermate).
 In questo modo possiamo centralizzare in questa classe eventuali funzionalità comuni a più schermate. Un esempio comune è un riferimento alla classe conforme al TkMvvmRouterProtocol utilizzato per la navigazione tra schermate.
 */
class BaseViewModel: TkMvvmViewModel {
  
  // MARK: - Properties
  // MARK: Class
  
  
  // MARK: Public
  
  
  // MARK: Private
  
  // Questo oggeto va OBBLIGATORIAMENTE creato lazy in modo che non crei riferimenti circolari in fase di resolve nell'IoC Container
  internal lazy var router: TkMvvmRouterProtocol = AppDelegate.container.resolve(TkMvvmRouterProtocol.self)!
  
  
  // MARK: - Methods
  // MARK: Class
  
  
  // MARK: Lifecycle
  
  
  // MARK: Custom accessors
  
  
  // MARK: IBActions
  
  
  // MARK: Public
  
  
  // MARK: Private
  
  
}

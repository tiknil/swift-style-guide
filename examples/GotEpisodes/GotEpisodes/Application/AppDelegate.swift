//
//  AppDelegate.swift
//  GotEpisodes
//
//  Created by Fabio Butti on 13/07/17.
//  Copyright © 2017 tiknil. All rights reserved.
//

import UIKit
import Swinject

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  public static let container: Container = {
    let container = Container()
    
    //************* HELPERS *************//
    container.register(TkMvvmRouterProtocol.self) { r in
      TkMvvmRouter(navigationController: r.resolve(UINavigationController.self)!, container: container)
      }.inObjectScope(.container)
    
    //************* MODELS *************//
    container.register(ApiServiceProtocol.self) { _ in
      return ApiService(with: .development) // Registrazione di una determinata implementazione di un protocollo di servizio
    }
    
    //************* VIEWMODELS *************//
    container.register(EpisodesViewModel.self) { r in
      return EpisodesViewModel(apiService: r.resolve(ApiServiceProtocol.self)!)
    }
    container.register(EpisodeDetailViewModel.self) { (r: Resolver, episode: Episode) in
      return EpisodeDetailViewModel(episode: episode)
    }
    
    //************* VIEWS *************//
    container.register(UINavigationController.self) { r in
      // Registrazione dell'implementazione di default di un tipo di base di UIKit: in questo caso è il navigation controller root dell'applicazione
      let navigationController = UINavigationController(rootViewController: r.resolve(UITabBarController.self)!)
      return navigationController
    }
    container.register(UITabBarController.self) { r in
      // Registrazione dell'implementazione di default di un tipo di base di UIKit: in questo caso è il tabbarcontroller dell'applicazione
      let tabBarController = UITabBarController()
      tabBarController.viewControllers = [r.resolve(EpisodesTableViewController.self)!]
      return tabBarController
    }
    container.register(EpisodesTableViewController.self) { r in
      // Registrazione del viewcontroller recuperandolo dallo storyboard
      let vc = EpisodesTableViewController.instantiateFrom(storyboardWithName: "Main")
      // Assegnazione del viewmodel
      vc.viewModel = r.resolve(EpisodesViewModel.self)
      return vc as! EpisodesTableViewController
    }
    container.register(EpisodeDetailViewController.self) { (r: Resolver, episode: Any?) in
      // Registrazione del viewcontroller recuperandolo dallo storyboard
      let vc = EpisodeDetailViewController.instantiateFrom(storyboardWithName: "Main")
      // Assegnazione del viewmodel
      vc.viewModel = r.resolve(EpisodeDetailViewModel.self, argument: episode as! Episode)
      return vc as! EpisodeDetailViewController
    }
    
    return container
    
  }()

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    // Creazione istanza window
    let window = UIWindow(frame: UIScreen.main.bounds)
    window.makeKeyAndVisible()
    self.window = window
    
    // Assegnazione prima schermata
    let router = AppDelegate.container.resolve(TkMvvmRouterProtocol.self) as! TkMvvmRouter
    window.rootViewController = router.navigationController
    
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }

}


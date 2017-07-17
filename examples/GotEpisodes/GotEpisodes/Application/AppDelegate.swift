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
  let container: Container = {
    let container = Container()
    
    // Models
    container.register(ApiServiceProtocol.self) { _ in
      return ApiService(with: .development)
    }
    
    // ViewModels
    
    // Views
    container.register(UITabBarController.self) { r in
      let tabBarController = UITabBarController()
      tabBarController.viewControllers = [r.resolve(EpisodesTableViewController.self)!]
      return tabBarController
    }
    container.register(EpisodesTableViewController.self) { r in
      let bundle = Bundle(for: EpisodesTableViewController.self)
      let episodesVc = UIStoryboard(name: "Main", bundle: bundle).instantiateViewController(withIdentifier: "EpisodesTableViewController") as! EpisodesTableViewController
      let episodesViewModel = EpisodesViewModel(viewController: episodesVc, apiService: r.resolve(ApiServiceProtocol.self)!)
      episodesVc.viewModel = episodesViewModel
      return episodesVc
    }
    
    return container
    
  }()

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Creazione istanza window
    let window = UIWindow(frame: UIScreen.main.bounds)
    window.makeKeyAndVisible()
    self.window = window    
    window.rootViewController = container.resolve(UITabBarController.self)
    
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


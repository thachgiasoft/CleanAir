//
//  AppDelegate.swift
//  CleanAir
//
//  Created by Marko Engelman on 20/11/2020.
//

import UIKit
import CleanAirModules
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  weak var rootController: UIViewController?
  var coordinator: RootCoordinator<UIViewController, AppDelegate>?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let rootNavigationController = UINavigationController()
    rootNavigationController.navigationBar.prefersLargeTitles = true
    rootController = rootNavigationController
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = rootNavigationController
    window?.makeKeyAndVisible()
    
    coordinator = RootCoordinator(initialView: rootNavigationController, factory: self)
    coordinator?.start()
    
    return true
  }
}

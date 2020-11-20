//
//  AppDelegate.swift
//  CleanAir
//
//  Created by Marko Engelman on 20/11/2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    let loader = ResourceLoader(
      client: URLSessionHTTPClient(session: .shared),
      url: APIURL.countries,
      mapper: ResourceMapper(CountryMapper.map).map
    )
    window?.rootViewController = CountriesUIComposer.makeView(with: loader)
    window?.makeKeyAndVisible()
    return true
  }
}


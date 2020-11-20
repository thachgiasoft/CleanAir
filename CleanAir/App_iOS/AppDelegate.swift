//
//  AppDelegate.swift
//  CleanAir
//
//  Created by Marko Engelman on 20/11/2020.
//

import UIKit
import CleanAirModules

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  weak var rootController: UIViewController?
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    let loader = ResourceLoader(
      client: URLSessionHTTPClient(session: .shared),
      url: APIURL.countries,
      mapper: ResourceMapper(CountryMapper.map).map
    )
    
    let loaderWithCaching = CountriesLoaderWithCaching(
      loader: loader,
      cacher: ResourceCacher(
        storage: RealmStorage(
          storeMapper: CountriesCasheMapper.map,
          loadMapper: CountriesCasheMapper.map
        ),
        policy: CountriesCachePolicy.validate
      )
    )
    
    window?.rootViewController = CountriesUIComposer.makeView(with: loaderWithCaching, selection: { [weak self] in self?.showCities(for: $0) })
    rootController = window?.rootViewController
    window?.makeKeyAndVisible()
    return true
  }
}

// MARK: - Private
private extension AppDelegate {
  func showCities(for country: Country) {
    let loader = ResourceLoader(
      client: URLSessionHTTPClient(session: .shared),
      url: APIURL.cities(for: country.code),
      mapper: ResourceMapper(CityMapper.map).map
    )
    let controller = CitiesUIComposer.makeView(with: loader, selection: { _ in })
    rootController?.show(controller, sender: self)
  }
}

extension ResourceLoader: CountriesLoader where Resource == [Country] { }

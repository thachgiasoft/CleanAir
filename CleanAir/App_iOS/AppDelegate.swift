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
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    let loader = ResourceLoader(
      client: URLSessionHTTPClient(session: .shared),
      url: APIURL.countries,
      mapper: ResourceResultsMapper(CountryMapper.map).map
    )
    
    let storage = RealmStorage(realm: { try! Realm() })
    
    let cacher = ResourceCacheCacher(
      storage: (storage.store),
      date: Date.init
    )
    
    let cacheLoader = ResourceCacheLoader(
      storage: (load: storage.load, remove: storage.remove),
      date: Date.init,
      policy: CountriesCachePolicy.validate
    )
    
    let loaderWithCaching = CountriesLoaderWithCaching(
      loader: loader,
      cacheLoader: cacheLoader,
      cacheCacher: cacher
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
      mapper: ResourceResultsMapper(CityMapper.map).map
    )
    
    let loaderWithValidation = CitiesLoaderWithStorageValidation(
      loader: loader,
      storage: RealmStorage(realm: { try! Realm() })
    )
    
    let service = FavouriteCityService(
      storage: RealmStorage(realm: { try! Realm() })
    )

    let controller = CitiesUIComposer.makeView(with: loaderWithValidation, service: service, selection: { _ in })
    rootController?.show(controller, sender: self)
  }
}

extension ResourceLoader: CountriesLoader where Resource == [Country] { }
extension ResourceLoader: CitiesLoader where Resource == [City] { }

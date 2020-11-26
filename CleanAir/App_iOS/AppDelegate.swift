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
    let loader = CountriesComponentsComposer.countriesLoader(client: Self.makeHTTPClient(), realm: { try! Realm() })
    let controller = CountriesUIComposer.makeView(with: loader, selection: { [weak self] in self?.showCities(for: $0) })
    let rootNavigationController = UINavigationController(rootViewController: controller)
    rootNavigationController.navigationBar.prefersLargeTitles = true
    
    rootController = rootNavigationController
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = rootNavigationController
    window?.makeKeyAndVisible()
    return true
  }
}

// MARK: - Private
private extension AppDelegate {
  func showCities(for country: Country) {
    let loader = ResourceLoader(
      client: Self.makeHTTPClient(),
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
  
  static func makeHTTPClient() -> HTTPClient {
    let client = URLSessionHTTPClient(session: .shared)
    return HTTPClientLogger(client: client)
  }
}
extension ResourceLoader: CitiesLoader where Resource == [City] { }

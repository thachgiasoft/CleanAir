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

// MARK: - Root
extension UIViewController: PresentingView {
  func show(view: UIViewController) {
    show(view, sender: self)
  }
}

extension AppDelegate {
  static func makeHTTPClient() -> HTTPClient {
    let client = URLSessionHTTPClient(session: .shared)
    return HTTPClientLogger(client: client)
  }
  
  static func makeRealm() -> Realm {
    return try! Realm()
  }
}

extension AppDelegate: RootFactory { }

extension AppDelegate: CitiesFactory {
  func makeFavouritesCitiesView(selection: @escaping CitySelector, onAdd: @escaping Add) -> UIViewController {
    let service = CitiesComponentsComposer.countriesFavouriteService(realm: Self.makeRealm)
    let storage = CitiesComponentsComposer.storage(realm: Self.makeRealm)
    let controller = CitiesUIComposer.makeFavouritesView(
      with: storage,
      service: service,
      onSelect: { selection($0.id) },
      onAdd: onAdd)
    return controller
  }
  
  func makeCitiesView(for countryId: CountryId, selection: @escaping CitySelector) -> UIViewController {
    let storage = CitiesComponentsComposer.storage(realm: Self.makeRealm)
    let loader = CitiesComponentsComposer.countriesLoader(client: Self.makeHTTPClient(), storage: storage, countryCode: countryId)
    let service = CitiesComponentsComposer.countriesFavouriteService(realm: Self.makeRealm)
    let controller = CitiesUIComposer.makeView(
      with: loader,
      service: service,
      onSelect: { selection($0.id) }
    )
    return controller
  }
  
  func makeMeasurementsViewFor(cityId: CityId) -> UIViewController {
    let loader = MeasurementsComponentsComposer.measurementsLoader(client: Self.makeHTTPClient(), cityId: cityId)
    let controller = MeasurementsUIComposer.makeMeasurementsView(with: loader)
    return controller
  }
  
  func makeCountriesView(selection: @escaping (CountryId) -> Void) -> UIViewController {
    let loader = CountriesComponentsComposer.countriesLoader(client: Self.makeHTTPClient(), realm: Self.makeRealm)
    let controller = CountriesUIComposer.makeView(with: loader, selection: { selection($0.code) })
    return controller
  }
}

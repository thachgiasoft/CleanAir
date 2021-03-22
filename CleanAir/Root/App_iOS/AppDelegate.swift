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
  var coordinator: RootCoordinator<UIViewController>?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let rootNavigationController = UINavigationController()
    rootNavigationController.navigationBar.prefersLargeTitles = true
    rootController = rootNavigationController
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = rootNavigationController
    window?.makeKeyAndVisible()
    
    coordinator = RootCoordinator(initialView: rootNavigationController)
    coordinator?.start(with: { self.favouriteCitiesView() })
    
    return true
  }
}

// MARK: - Private
private extension AppDelegate {
  func openCountry(country: Country) {
    rootController?.show(citiviesView(for: country), sender: self)
  }
  
  func openCity(city: City) {
    let loader = MeasurementsComponentsComposer.measurementsLoader(client: Self.makeHTTPClient(), cityId: city.id)
    let controller = MeasurementsUIComposer.makeMeasurementsView(with: loader)
    rootController?.show(controller, sender: self)
  }
  
  func showCountries() {
    rootController?.show(countriresView(), sender: self)
  }
  
  func countriresView() -> UIViewController {
    let loader = CountriesComponentsComposer.countriesLoader(client: Self.makeHTTPClient(), realm: Self.makeRealm)
    let controller = CountriesUIComposer.makeView(with: loader, selection: { [weak self] in self?.openCountry(country: $0) })
    return controller
  }
  
  func favouriteCitiesView() -> UIViewController {
    let service = CitiesComponentsComposer.countriesFavouriteService(realm: Self.makeRealm)
    let storage = CitiesComponentsComposer.storage(realm: Self.makeRealm)
    let controller = CitiesUIComposer.makeFavouritesView(
      with: storage,
      service: service,
      onSelect: { [weak self] in self?.openCity(city: $0) },
      onAdd: { [weak self] in self?.showCountries() })
    return controller
  }
  
  func citiviesView(for country: Country) -> UIViewController {
    let storage = CitiesComponentsComposer.storage(realm: Self.makeRealm)
    let loader = CitiesComponentsComposer.countriesLoader(client: Self.makeHTTPClient(), storage: storage, countryCode: country.code)
    let service = CitiesComponentsComposer.countriesFavouriteService(realm: Self.makeRealm)
    let controller = CitiesUIComposer.makeView(with: loader, service: service, onSelect: { [weak self] in self?.openCity(city: $0) })
    return controller
  }
  
  static func makeHTTPClient() -> HTTPClient {
    let client = URLSessionHTTPClient(session: .shared)
    return HTTPClientLogger(client: client)
  }
  
  static func makeRealm() -> Realm {
    return try! Realm()
  }
}

// MARK: - Root
extension UIViewController: PresentingView {
  func show(view: UIViewController) {
    show(view, sender: self)
  }
}

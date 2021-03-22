//
//  AppDelegate+Root.swift
//  CleanAir
//
//  Created by Marko Engelman on 22/03/2021.
//

import UIKit
import RealmSwift
import CleanAirModules

// MARK: - Root
extension UIViewController: PresentingView {
  func show(view: UIViewController) {
    show(view, sender: self)
  }
  
  func present(view: UIViewController) {
    if navigationController == nil {
      present(UINavigationController(rootViewController: view), animated: true)
    } else {
      present(view, animated: true)
    }
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

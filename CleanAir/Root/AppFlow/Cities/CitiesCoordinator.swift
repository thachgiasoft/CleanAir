//
//  CitiesCoordinator.swift
//  CleanAir
//
//  Created by Marko Engelman on 22/03/2021.
//

import Foundation

final class CitiesCoordinator<RootView, Factory> where RootView: PresentingView, Factory: CitiesFactory, Factory.View == RootView.View {
  typealias View = RootView.View
  
  let initialView: RootView
  let factory: Factory
  
  init(initialView: RootView, factory: Factory) {
    self.initialView = initialView
    self.factory = factory
  }
  
  func start() {
    let view = factory
      .makeFavouritesCitiesView(
        selection: { [weak self] in self?.showMeasurements(for: $0) },
        onAdd: { [weak self] in self?.openAllCountries() }
      )
    initialView.show(view: view)
  }
}

// MARK: - Private
private extension CitiesCoordinator {
  func showMeasurements(for city: String) {
    initialView.show(view: factory.makeMeasurementsViewFor(cityId: city))
  }
  
  func openAllCountries() {
    initialView.show(view: factory.makeCountriesView(selection: { [weak self] in self?.showCities(for: $0) }))
  }
  
  func showCities(for country: String) {
    initialView.show(view: factory.makeCitiesView(for: country, selection: { [weak self] in
      self?.showMeasurements(for: $0)
    }))
  }
}

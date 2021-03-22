//
//  CitiesFactory.swift
//  CleanAir
//
//  Created by Marko Engelman on 22/03/2021.
//

import Foundation

protocol CitiesFactory {
  associatedtype View
  typealias CityId = String
  typealias CountryId = String
  
  typealias CitySelector = (CityId) -> Void
  typealias CountrySelector = (CountryId) -> Void
  typealias Add = () -> Void
  
  func makeFavouritesCitiesView(selection: @escaping CitySelector, onAdd: @escaping Add) -> View
  func makeCitiesView(for countryId: CountryId, selection: @escaping CitySelector) -> View
  func makeMeasurementsViewFor(cityId: CityId) -> View
  func makeCountriesView(selection: @escaping CountrySelector) -> View
}

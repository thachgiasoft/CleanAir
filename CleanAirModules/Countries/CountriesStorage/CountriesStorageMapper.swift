//
//  CountriesStorageMapper.swift
//  CleanAirModules
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation
import RealmSwift

public final class CountriesStorageMapper {
  public static func map(_ models: [Country]) -> [LocalCountry] {
    return models.map(CountriesStorageMapper.map)
  }
  
  public static func map(_ local: Results<LocalCountry>) -> [Country] {
    return local.map {
      return Country(code: $0.code, name: $0.name, totalNumberOfMeasurements: $0.count, numberOfMeasuredCities: $0.cities, numberOfMeasuringLocations: $0.locations)
    }
  }
}

// MARK: - Private
private extension CountriesStorageMapper {
  static func map(_ model: Country) -> LocalCountry {
    let rlmModel = LocalCountry()
    rlmModel.code = model.code
    rlmModel.name = model.name
    rlmModel.count = model.totalNumberOfMeasurements
    rlmModel.cities = model.numberOfMeasuredCities
    rlmModel.locations = model.numberOfMeasuringLocations
    return rlmModel
  }
}

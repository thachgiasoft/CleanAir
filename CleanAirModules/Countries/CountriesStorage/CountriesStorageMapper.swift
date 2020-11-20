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
    return models.compactMap { model in
      let rlmModel = LocalCountry()
      rlmModel.code = model.code
      rlmModel.name = model.name
      rlmModel.count = model.totalNumberOfMeasurements
      rlmModel.cities = model.numberOfMeasuredCities
      rlmModel.locations = model.numberOfMeasuringLocations
      return rlmModel
    }
  }
  
  public static func map(_ local: Results<LocalCountry>) -> [Country] {
    return local.compactMap {
      guard let name = $0.name else { return nil }
      return Country(code: $0.code, name: name, totalNumberOfMeasurements: $0.count, numberOfMeasuredCities: $0.cities, numberOfMeasuringLocations: $0.locations)
    }
  }
}

//
//  CountriesStorageMapper.swift
//  CleanAirModules
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

public final class CountriesStorageMapper {
  public enum CacheError: Swift.Error {
    case invalidCacheResult
  }
  
  public static func map(_ models: [Country]) -> [LocalCountry] {
    return models.map(CountriesStorageMapper.map)
  }
  
  public static func map(_ model: Country) -> LocalCountry {
    let rlmModel = LocalCountry()
    rlmModel.code = model.code
    rlmModel.name = model.name
    rlmModel.count = model.totalNumberOfMeasurements
    rlmModel.cities = model.numberOfMeasuredCities
    rlmModel.locations = model.numberOfMeasuringLocations
    return rlmModel
  }
  
  public static func map(_ local: LocalCountry) -> Country {
    return Country(
      code: local.code,
      name: local.name,
      totalNumberOfMeasurements: local.count,
      numberOfMeasuredCities: local.cities,
      numberOfMeasuringLocations: local.locations
    )
  }
}

//
//  CitiesStorageMapper.swift
//  CleanAirModules
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

public final class CitiesStorageMapper {
  public static func map(_ models: [City]) -> [LocalCity] {
    return models.map(CitiesStorageMapper.map)
  }
  
  public static func map(_ model: City) -> LocalCity {
    let rlmModel = LocalCity()
    rlmModel.name = model.name
    rlmModel.country = model.country
    rlmModel.availableLocationsCount = model.availableLocationsCount
    rlmModel.measurementsCount = model.measurementsCount
    rlmModel.isFavourite = model.isFavourite
    return rlmModel
  }
  
  public static func map(_ local: LocalCity) -> City {
    return City(
      name: local.name,
      country: local.country,
      measurementsCount: local.measurementsCount,
      availableLocationsCount: local.availableLocationsCount,
      isFavourite: local.isFavourite
    )
  }
}

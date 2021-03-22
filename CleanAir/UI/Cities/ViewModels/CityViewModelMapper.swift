//
//  CityViewModelMapper.swift
//  CleanAir
//
//  Created by Marko Engelman on 21/11/2020.
//

import Foundation
import CleanAirModules

final class CityViewModelMapper {
  static func map(models: [City]) -> [CityViewModel] {
    return models.map(CityViewModelMapper.map)
  }
  
  static func map(model: City) -> CityViewModel {
    return CityViewModel(
      name: model.name,
      country: model.country,
      measurementsCount: model.measurementsCount,
      availableLocationsCount: model.availableLocationsCount,
      isFavourite: model.isFavourite
    )
  }
}

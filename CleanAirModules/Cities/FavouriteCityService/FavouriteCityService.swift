//
//  FavouriteCityService.swift
//  CleanAirModules
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

public class FavouriteCityService {
  let storage: CityStorage
  
  public init(storage: CityStorage) {
    self.storage = storage
  }
  
  public func toggl(for city: City) throws -> City {
    let isFavourite = !city.isFavourite
    let updatedCity = City(name: city.name, country: city.country, measurementsCount: city.measurementsCount, availableLocationsCount: city.availableLocationsCount, isFavourite: isFavourite)
    
    isFavourite
      ? try storage.store(updatedCity)
      : try storage.remove(cityId: city.id)
    
    return updatedCity
  }
}

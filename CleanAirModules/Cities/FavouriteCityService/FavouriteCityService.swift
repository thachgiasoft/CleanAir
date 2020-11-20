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
  
  public func toggl(for city: City, completion: (Swift.Result<City, Error>) -> Void) {
    let isFavourite = !city.isFavourite
    let updatedCity = City(name: city.name, country: city.country, measurementsCount: city.measurementsCount, availableLocationsCount: city.availableLocationsCount, isFavourite: isFavourite)
    let result = storage.store(updatedCity)
    completion(result.map { updatedCity })
  }
}

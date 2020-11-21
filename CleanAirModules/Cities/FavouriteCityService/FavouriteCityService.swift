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
  
  public func toggl(for city: City, completion: @escaping (Swift.Result<City, Error>) -> Void) {
    let isFavourite = !city.isFavourite
    let updatedCity = City(name: city.name, country: city.country, measurementsCount: city.measurementsCount, availableLocationsCount: city.availableLocationsCount, isFavourite: isFavourite)
    
    let result: Result<Void, Error>
    if isFavourite {
      result = storage.store(updatedCity)
    } else {
      result = storage.remove(objectId: city.id)
    }
    completion(result.map { updatedCity })
  }
}

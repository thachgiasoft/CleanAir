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
    var city = city
    city.isFavourite
      ? try { city.resetFavourite(); try storage.remove(cityId: city.id) }()
      : try { city.makeFavourite(); try storage.store(city) }()
    
    return city
  }
}

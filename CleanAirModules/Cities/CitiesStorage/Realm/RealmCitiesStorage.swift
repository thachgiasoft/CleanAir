//
//  RealmCitiesStorage.swift
//  CleanAirModules
//
//  Created by Marko Engelman on 23/11/2020.
//

import Foundation

extension RealmStorage: CityStorage {
  public func store(_ city: City) throws {
    try insert(object: CitiesStorageMapper.map(city))
  }
  
  public func remove(cityId: String) throws {
    try delete(object: RealmCity.self, forId: cityId)
  }
  
  public func load(cityId: String) -> City? {
    guard let local = find(object: RealmCity.self, forId: cityId) else { return nil }
    return CitiesStorageMapper.map(local)
  }
  
  public func load(with request: CityStorageLoadRequest) -> [City] {
    return find(object: RealmCity.self)
      .map { CitiesStorageMapper.map($0) }
      .filter { $0.isFavourite == request.isFavourite }
  }
}

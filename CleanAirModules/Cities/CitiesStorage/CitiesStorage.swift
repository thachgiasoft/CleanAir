//
//  CitiesStorage.swift
//  CleanAirModules
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

public struct CityStorageLoadRequest {
  let isFavourite: Bool
  
  public init(isFavourite: Bool) {
    self.isFavourite = isFavourite
  }
}

public protocol CityStorage {
  func store(_ city: City) throws
  func remove(cityId: String) throws
  func load(cityId: String) -> City?
}

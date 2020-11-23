//
//  CitiesStorage.swift
//  CleanAirModules
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

public protocol CityStorage {
  func store(_ object: City) throws
  func remove(objectId: Any) throws
  func load() -> [City]?
  func load(objectId: Any) -> City?
}

extension RealmStorage: CityStorage where LocalObject == City, RealmObject == LocalCity { }

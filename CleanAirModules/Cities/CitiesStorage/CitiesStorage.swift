//
//  CitiesStorage.swift
//  CleanAirModules
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

public protocol CityStorage {
  typealias StoreResult = Swift.Result<Void, Error>
  typealias RemoveResult = Swift.Result<Void, Error>
  
  func store(_ object: City) throws
  func load() -> [City]?
  
  @discardableResult
  func load(objectId: Any) -> City?
  
  func remove(objectId: Any, completion: @escaping (RemoveResult) -> Void)
}

extension RealmStorage: CityStorage where LocalObject == City, RealmObject == LocalCity { }

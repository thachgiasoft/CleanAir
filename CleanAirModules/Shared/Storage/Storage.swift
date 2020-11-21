//
//  Storage.swift
//  CleanAirModules
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

public protocol Storage {
  associatedtype StorableObject
  
  typealias StoreResult = Swift.Result<Void, Error>
  typealias LoadResult = Swift.Result<StorableObject, Error>
  typealias RemoveResult = Swift.Result<Void, Error>
  
  @discardableResult
  func store(_ object: StorableObject) -> StoreResult
  
  @discardableResult
  func load() -> LoadResult
  
  @discardableResult
  func load(objectId: Any) -> LoadResult
  
  @discardableResult
  func remove(_ object: StorableObject) -> RemoveResult
  
  @discardableResult
  func remove(objectId: Any) -> RemoveResult
}

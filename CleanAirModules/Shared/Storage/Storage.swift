//
//  Storage.swift
//  CleanAirModules
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

public protocol Storage {
  associatedtype StorableObject
  associatedtype LoadableObject
  
  typealias StoreResult = Swift.Result<Void, Error>
  typealias LoadResult = Swift.Result<LoadableObject, Error>
  
  typealias RemoveResult = Swift.Result<Void, Error>
  
  func store(_ object: StorableObject) throws
  func load() -> [LoadableObject]?
  
  @discardableResult
  func load(objectId: Any) -> LoadableObject?
  
  @discardableResult
  func remove(_ object: StorableObject) -> RemoveResult
  
  @discardableResult
  func remove(objectId: Any) -> RemoveResult
}

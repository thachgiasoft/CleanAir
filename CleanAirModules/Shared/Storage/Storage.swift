//
//  Storage.swift
//  CleanAirModules
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

public protocol Storage {
  associatedtype StorageObject
  
  typealias StoreResult = Swift.Result<Void, Error>
  typealias LoadResult = Swift.Result<StorageObject, Error>
  
  typealias RemoveResult = Swift.Result<Void, Error>
  
  func store(_ object: StorageObject) throws
  func load() -> [StorageObject]?
  
  @discardableResult
  func load(objectId: Any) -> StorageObject?
  
  func remove(objectId: Any) throws
}

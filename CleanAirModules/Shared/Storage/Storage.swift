//
//  Storage.swift
//  CleanAirModules
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

public protocol Storage {
  associatedtype StorageObject
  typealias RemoveResult = Swift.Result<Void, Error>
  
  func store(_ object: StorageObject) throws
  func load() -> [StorageObject]?
  
  @discardableResult
  func load(objectId: Any) -> StorageObject?
  
  func remove(objectId: Any, completion: @escaping (RemoveResult) -> Void)
}

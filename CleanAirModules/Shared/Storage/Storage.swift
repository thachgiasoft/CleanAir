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
  
  @discardableResult
  func store(_ object: StorableObject) -> StoreResult
  
  @discardableResult
  func load() -> LoadResult
}

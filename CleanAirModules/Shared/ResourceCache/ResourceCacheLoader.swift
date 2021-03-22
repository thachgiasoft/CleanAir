//
//  ResourceCacheLoader.swift
//  CleanAirModules
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

public class ResourceCacheLoader<Resource> {
  public typealias ResourceCacheStorage = (
    load: (() -> [ResourceCache<Resource>]),
    remove: ((ResourceCache<Resource>) throws -> Void)
  )
  
  let storage: ResourceCacheStorage
  let date: () -> Date
  let policy: (_ timestamp: Date) -> Bool
  
  enum ResourceCacheError: Swift.Error {
    case storage
    case cacheExpired
  }
  
  public init(storage: ResourceCacheStorage, date: @escaping () -> Date, policy: @escaping (_ timestamp: Date) -> Bool) {
    self.storage = storage
    self.date = date
    self.policy = policy
  }
  
  public func load() -> Resource? {
    let cacheLoad = storage.load().first
    switch cacheLoad {
    case let .some(cache) where policy(cache.timestamp):
      return cache.resource
      
    case let .some(cache):
      try? storage.remove(cache)
      return nil
      
    case .none:
      return nil
    }
  }
}

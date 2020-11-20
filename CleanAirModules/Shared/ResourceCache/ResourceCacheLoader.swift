//
//  ResourceCacheLoader.swift
//  CleanAirModules
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

public class ResourceCacheLoader<Resource, ResourceStorage> where ResourceStorage: Storage {
  let storage: ResourceStorage
  let date: () -> Date
  let policy: (_ timeStamp: TimeInterval) -> Bool
  
  enum ResourceCacheError: Swift.Error {
    case storage
    case cacheExpired
  }
  
  public init(storage: ResourceStorage, date: @escaping () -> Date = Date.init, policy: @escaping (_ timeStamp: TimeInterval) -> Bool) {
    self.storage = storage
    self.date = date
    self.policy = policy
  }
  
  public func cache(resource: Resource) where ResourceStorage.StorableObject == ResourceCache<Resource> {
    storage.store(ResourceCache(timestamp: date().timeIntervalSince1970, resource: resource))
  }
  
  public func load() throws -> Resource where ResourceStorage.StorableObject == ResourceCache<Resource> {
    let loadResult = storage.load()
    switch loadResult {
    case let .success(cache) where policy(cache.timestamp):
      return cache.resource
      
    case .success:
      throw ResourceCacheError.cacheExpired
      
    case .failure:
      throw ResourceCacheError.storage
    }
  }
}

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
  
  enum ResourceCacheError: Swift.Error {
    case storage
  }
  
  public init(storage: ResourceStorage, date: @escaping () -> Date = Date.init ) {
    self.storage = storage
    self.date = date
  }
  
  public func cache(resource: Resource) where ResourceStorage.StorableObject == ResourceCache<Resource> {
    storage.store(ResourceCache(timestamp: date().timeIntervalSince1970, resource: resource))
  }
  
  public func load() throws -> Resource where ResourceStorage.StorableObject == ResourceCache<Resource> {
    let loadResult = storage.load()
    switch loadResult {
    case let .success(cache):
      return cache.resource
      
    case .failure:
      throw ResourceCacheError.storage
    }
  }
}

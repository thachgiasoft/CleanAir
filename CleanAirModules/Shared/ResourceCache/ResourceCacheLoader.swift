//
//  ResourceCacheLoader.swift
//  CleanAirModules
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

public class ResourceCacheLoader<Resource, ResourceStorage> where ResourceStorage: Storage, ResourceStorage.StorableObject == Resource {
  let storage: ResourceStorage
  
  enum ResourceCacheError: Swift.Error {
    case storage
  }
  
  public init(storage: ResourceStorage) {
    self.storage = storage
  }
  
  public func cache(resource: Resource) {
    storage.store(resource)
  }
  
  public func load() throws -> Resource {
    let loadResult = storage.load()
    switch loadResult {
    case let .success(resource):
      return resource
      
    case .failure:
      throw ResourceCacheError.storage
    }
  }
}

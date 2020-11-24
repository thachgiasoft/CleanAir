//
//  ResourceCacheLoader.swift
//  CleanAirModules
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

public class ResourceCacheLoader<Resource, ResourceStorage> where ResourceStorage: Storage {
  public typealias ResourceCacheStorage = (
    load: (() -> [ResourceCache<Resource>]),
    remove: ((_ id: Int) throws -> Void)
  )
  
  let storage: ResourceCacheStorage
  let date: () -> Date
  let policy: (_ timeStamp: TimeInterval) -> Bool
  
  public typealias CacheCompletion = (Swift.Result<Void, Error>) -> Void
  enum ResourceCacheError: Swift.Error {
    case storage
    case cacheExpired
  }
  
  public init(storage: ResourceCacheStorage, date: @escaping () -> Date, policy: @escaping (_ timeStamp: TimeInterval) -> Bool) {
    self.storage = storage
    self.date = date
    self.policy = policy
  }
  
  public func cache(resource: Resource) throws where ResourceStorage.StorageObject == ResourceCache<Resource> { }
  
  public func load() -> Resource? {
    let cacheLoad = storage.load().first
    switch cacheLoad {
    case let .some(cache) where policy(Double(cache.id)):
      return cache.resource
      
    case let .some(cache):
      try? storage.remove(cache.id)
      return nil
      
    case .none:
      return nil
    }
  }
}

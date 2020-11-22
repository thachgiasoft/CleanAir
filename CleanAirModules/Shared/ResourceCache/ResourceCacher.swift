//
//  ResourceCacher.swift
//  CleanAirModules
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

public class ResourceCacher<Resource, ResourceStorage> where ResourceStorage: Storage {
  let storage: ResourceStorage
  let date: () -> Date
  let policy: (_ timeStamp: TimeInterval) -> Bool
  
  public typealias CacheCompletion = (Swift.Result<Void, Error>) -> Void
  enum ResourceCacheError: Swift.Error {
    case storage
    case cacheExpired
  }
  
  public init(storage: ResourceStorage, date: @escaping () -> Date = Date.init, policy: @escaping (_ timeStamp: TimeInterval) -> Bool) {
    self.storage = storage
    self.date = date
    self.policy = policy
  }
  
  public func cache(resource: Resource, completion: @escaping CacheCompletion) where ResourceStorage.StorageObject == ResourceCache<Resource> {
    let cache = ResourceCache(id: Int(date().timeIntervalSince1970), resource: resource)
    storage.store(cache, completion: completion)
  }
  
  public func load() -> Resource? where ResourceStorage.StorageObject == ResourceCache<Resource> {
    let cacheLoad = storage.load()?.first
    switch cacheLoad {
    case let .some(cache) where policy(Double(cache.id)):
      return cache.resource
      
    case let .some(cache):
      storage.remove(objectId: cache.id, completion: { _ in })
      return nil
      
    case .none:
      return nil
    }
  }
}

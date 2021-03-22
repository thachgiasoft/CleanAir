//
//  ResourceCacheCacher.swift
//  CleanAirModules
//
//  Created by Marko Engelman on 24/11/2020.
//

import Foundation

public class ResourceCacheCacher<Resource> {
  public typealias ResourceCacheStorage = ((_: ResourceCache<Resource>) throws -> Void)
  let storage: ResourceCacheStorage
  let date: () -> Date
  
  public init(storage: @escaping ResourceCacheStorage, date: @escaping () -> Date) {
    self.storage = storage
    self.date = date
  }
  
  public func cache(resource: Resource) throws {
    let timestamp = date()
    let cache = ResourceCache(
      id: Int(timestamp.timeIntervalSince1970),
      timestamp: timestamp,
      resource: resource
    )
    try storage(cache)
  }
}

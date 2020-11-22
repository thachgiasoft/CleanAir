//
//  ResourceCacherTests.swift
//  CleanAirModulesTests
//
//  Created by Marko Engelman on 22/11/2020.
//

import XCTest
@testable import CleanAirModules

class ResourceCacherTests: XCTestCase {
  
}

// MARK: - Private
private extension ResourceCacherTests {
  typealias AnyType = String
  typealias AnyTypeCache = ResourceCache<AnyType>
  typealias AnyTypeStore = ResourceStorage
  typealias AnyTypeCacher = ResourceCacher<AnyType, AnyTypeStore>
  
  func makeSUT() -> (AnyTypeCacher, AnyTypeStore)  {
    let store = AnyTypeStore()
    let date = Date()
    let cacher = ResourceCacher<AnyType, AnyTypeStore>(
      storage: store,
      date: { date },
      policy: { $0 <= date.timeIntervalSince1970 }
    )
    return (cacher, store)
  }
  
  class ResourceStorage: Storage {
    var caches: [Int: AnyTypeCache] = [:]
    
    func remove(objectId: Any, completion: @escaping (RemoveResult) -> Void) {
      if let id = objectId as? Int {
        caches.removeValue(forKey: id)
      }
      completion(.success(()))
    }
    
    func store(_ object: AnyTypeCache, completion: @escaping (StoreResult) -> Void) {
      caches[object.id] = object
      completion(.success(()))
    }
    
    func load() -> [AnyTypeCache]? {
      return caches.map { $0.value }
    }
    
    func load(objectId: Any) -> AnyTypeCache? {
      cacheLoadCalls += 1
      if let id = objectId as? Int {
        return caches[id]
      } else {
        return nil
      }
    }
  }
}

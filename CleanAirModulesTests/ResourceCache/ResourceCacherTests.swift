//
//  ResourceCacherTests.swift
//  CleanAirModulesTests
//
//  Created by Marko Engelman on 22/11/2020.
//

import XCTest
@testable import CleanAirModules

class ResourceCacherTests: XCTestCase {
  func test_init_has_zeroSideEffects_onStore() {
    let (_, store) = makeSUT()
    XCTAssertEqual(store.cacheCalls, .zero)
    XCTAssertEqual(store.cacheLoadCalls, .zero)
    XCTAssertEqual(store.cacheRemoveCalls, .zero)
  }
  
  func test_cache_insertsCacheIntoStore() {
    let (sut, store) = makeSUT()
    let anyResource: AnyType = "AnyType"
    XCTAssertEqual(store.cacheCalls, .zero)
    let exp = expectation(description: "Waiting to cache")
    sut.cache(resource: anyResource) { _ in
      exp.fulfill()
    }
    
    wait(for: [exp], timeout: 1.0)
    XCTAssertEqual(store.cacheCalls, 1)
    XCTAssertEqual(store.caches.first?.value.resource, anyResource)
  }
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
    var cacheLoadCalls: Int = 0
    var cacheRemoveCalls: Int = 0
    var cacheCalls: Int { caches.count }
    
    func remove(objectId: Any, completion: @escaping (RemoveResult) -> Void) {
      if let id = objectId as? Int {
        caches.removeValue(forKey: id)
      }
      completion(.success(()))
      cacheRemoveCalls += 1
    }
    
    func store(_ object: AnyTypeCache, completion: @escaping (StoreResult) -> Void) {
      caches[object.id] = object
      completion(.success(()))
    }
    
    func load() -> [AnyTypeCache]? {
      cacheLoadCalls += 1
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

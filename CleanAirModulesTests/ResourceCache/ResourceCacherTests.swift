//
//  ResourceCacherTests.swift
//  CleanAirModulesTests
//
//  Created by Marko Engelman on 24/11/2020.
//

import XCTest
@testable import CleanAirModules

class ResourceCacherTests: XCTestCase {
  func test_init_has_zeroSideEffects_onStore() {
    let (_, store) = makeSUT()
    XCTAssertEqual(store.cacheCalls, .zero)
  }
  
  func test_cache_insertsCacheIntoStore() throws {
    let (sut, store) = makeSUT()
    let resource = anyResource
    XCTAssertEqual(store.cacheCalls, .zero)
    try sut.cache(resource: resource)
    XCTAssertEqual(store.cacheCalls, 1)
    XCTAssertEqual(store.caches.first?.value.resource, resource)
  }
}

// MARK: - Private
private extension ResourceCacherTests {
  typealias AnyType = String
  typealias AnyTypeCache = ResourceCache<AnyType>
  typealias AnyTypeStore = ResourceStorage
  typealias AnyTypeCacher = ResourceCacheCacher<AnyType>
  
  func makeSUT(date: @escaping () -> Date = Date.init, policy: @escaping (Double) -> Bool = { _ in true }) -> (AnyTypeCacher, AnyTypeStore)  {
    let store = AnyTypeStore()
    let cacher = ResourceCacheCacher<AnyType>(
      storage: store.store,
      date: date
    )
    return (cacher, store)
  }
}

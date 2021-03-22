//
//  ResourceCacherTests.swift
//  CleanAirModulesTests
//
//  Created by Marko Engelman on 22/11/2020.
//

import XCTest
@testable import CleanAirModules

class ResourceCacheLoaderTests: XCTestCase {
  func test_init_has_zeroSideEffects_onStore() {
    let (_, store) = makeSUT()
    XCTAssertEqual(store.cacheCalls, .zero)
    XCTAssertEqual(store.cacheLoadCalls, .zero)
    XCTAssertEqual(store.cacheRemoveCalls, .zero)
  }
  
  func test_init_has_zeroSideEffects_onInjectedData() {
    let date = Date()
    let store = AnyTypeStore()
    let sut = ResourceCacheLoader<AnyType>(
      storage: (
        store.load,
        store.remove
      ),
      date: { date },
      policy: { _ in return true }
    )
    XCTAssertEqual(date, sut.date())
  }
  
  func test_cache_loads_validCache() throws {
    let (sut, store) = makeSUT(policy: { _ in true })
    try store.store(anyCache())
    XCTAssertNotNil(sut.load())
  }
  
  func test_laod_deliversNil_onExpiredCache() throws {
    let (sut, store) = makeSUT(policy: { _ in false })
    XCTAssertEqual(store.cacheCalls, .zero)
    try store.store(anyCache())
    XCTAssertNil(sut.load())
  }

  func test_laod_removes_expiredCache() throws {
    let (sut, store) = makeSUT(policy: { _ in false })
    XCTAssertEqual(store.cacheCalls, .zero)
    XCTAssertEqual(store.cacheRemoveCalls, .zero)
    try store.store(anyCache())
    _ = sut.load()
    XCTAssertEqual(store.cacheRemoveCalls, 1)
  }
  
  func test_laod_deliversNil_onEmptyCache() {
    let (sut, store) = makeSUT(policy: { _ in false })
    XCTAssertEqual(store.cacheCalls, .zero)
    _ = sut.load()
    XCTAssertNil(sut.load())
  }
}

// MARK: - Private
private extension ResourceCacheLoaderTests {
  typealias AnyType = String
  typealias AnyTypeCache = ResourceCache<AnyType>
  typealias AnyTypeStore = ResourceStorage
  typealias AnyTypeCacher = ResourceCacheLoader<AnyType>
  
  func makeSUT(date: @escaping () -> Date = Date.init, policy: @escaping (Date) -> Bool = { _ in true }) -> (AnyTypeCacher, AnyTypeStore)  {
    let store = AnyTypeStore()
    let cacher = ResourceCacheLoader<AnyType>(
      storage: (store.load, store.remove),
      date: date,
      policy: policy
    )
    return (cacher, store)
  }
  
  func anyCache() -> ResourceCache<AnyType> {
    return ResourceCache(
      id: 1,
      timestamp: Date(),
      resource: anyResource
    )
  }
}

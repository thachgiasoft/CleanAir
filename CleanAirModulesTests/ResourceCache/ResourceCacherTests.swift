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
  
  func test_init_has_zeroSideEffects_onInjectedData() {
    let date = Date()
    let store = AnyTypeStore()
    let sut = ResourceCacher<AnyType, AnyTypeStore>(
      storage: store,
      date: { date },
      policy: { _ in return true }
    )
    XCTAssertEqual(date, sut.date())
  }
  
  func test_cache_insertsCacheIntoStore() {
    let (sut, store) = makeSUT()
    let resource = anyResource
    XCTAssertEqual(store.cacheCalls, .zero)
    let exp = expectation(description: "Waiting to cache")
    sut.cache(resource: resource) { _ in
      exp.fulfill()
    }
    
    wait(for: [exp], timeout: 1.0)
    XCTAssertEqual(store.cacheCalls, 1)
    XCTAssertEqual(store.caches.first?.value.resource, resource)
  }
  
  func test_cache_loads_validCache() {
    let (sut, store) = makeSUT(policy: { _ in true })
    let resource = anyResource
    XCTAssertEqual(store.cacheCalls, .zero)
    let exp1 = expectation(description: "Waiting to cache insertion")
    sut.cache(resource: resource) { _ in
      exp1.fulfill()
    }
    
    wait(for: [exp1], timeout: 1.0)
    XCTAssertNotNil(sut.load())
  }
  
  func test_laod_deliversNil_onExpiredCache() {
    let (sut, store) = makeSUT(policy: { _ in false })
    let resource = anyResource
    XCTAssertEqual(store.cacheCalls, .zero)
    let exp1 = expectation(description: "Waiting to cache insertion")
    sut.cache(resource: resource) { _ in
      exp1.fulfill()
    }
    
    wait(for: [exp1], timeout: 1.0)
    XCTAssertNil(sut.load())
  }
  
  func test_laod_removes_expiredCache() {
    let (sut, store) = makeSUT(policy: { _ in false })
    let resource = anyResource
    XCTAssertEqual(store.cacheCalls, .zero)
    let exp1 = expectation(description: "Waiting to cache insertion")
    sut.cache(resource: resource) { _ in
      exp1.fulfill()
    }
    
    _ = sut.load()
    
    wait(for: [exp1], timeout: 1.0)
    XCTAssertTrue(store.caches.isEmpty)
  }
  
  func test_laod_deliversNil_onEmptyCache() {
    let (sut, store) = makeSUT(policy: { _ in false })
    XCTAssertEqual(store.cacheCalls, .zero)
    _ = sut.load()
    XCTAssertNil(sut.load())
  }
}

// MARK: - Private
private extension ResourceCacherTests {
  typealias AnyType = String
  typealias AnyTypeCache = ResourceCache<AnyType>
  typealias AnyTypeStore = ResourceStorage
  typealias AnyTypeCacher = ResourceCacher<AnyType, AnyTypeStore>
  
  func makeSUT(date: @escaping () -> Date = Date.init, policy: @escaping (Double) -> Bool = { _ in true }) -> (AnyTypeCacher, AnyTypeStore)  {
    let store = AnyTypeStore()
    let cacher = ResourceCacher<AnyType, AnyTypeStore>(
      storage: store,
      date: date,
      policy: policy
    )
    return (cacher, store)
  }
}

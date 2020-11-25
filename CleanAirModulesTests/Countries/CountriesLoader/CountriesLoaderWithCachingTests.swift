//
//  CountriesLoaderWithCachingTests.swift
//  CleanAirModulesTests
//
//  Created by Marko Engelman on 25/11/2020.
//

import XCTest
@testable import CleanAirModules

class CountriesLoaderWithCachingTests: XCTestCase {
  func test_init_doesntHaveSideEffects_onLoaderAndStorage() {
    let (_, loader, storage) = makeSUT()
    XCTAssertNil(loader.completion)
    XCTAssertNil(storage.stored)
  }

  func test_load_hasNoSideEffectOnLoader_onDeliveredCache() throws  {
    let (sut, loader, store) = makeSUT()
    let exp = expectation(description: "Waiting for deliver")
    try store.store(anyCountriesCache())
    sut.load { _ in exp.fulfill() }
    wait(for: [exp], timeout: 1.0)
    XCTAssertEqual(loader.loadCalls, .zero)
  }
  
  func test_load_triggersLoaderOnce_onNoCacheDeliver() throws  {
    let (sut, loader, _) = makeSUT()
    let exp = expectation(description: "Waiting for deliver")
    sut.load { _ in exp.fulfill() }
    loader.complete(with: anyCountry())
    wait(for: [exp], timeout: 1.0)
    XCTAssertTrue((loader.loadCalls == 1))
  }
  
  func test_load_loadsCachedCountries() throws {
    let (sut, _, store) = makeSUT()
    let exp = expectation(description: "Waiting for deliver")

    let cache = anyCountriesCache()
    let cachedCountries = cache.resource
    var loadedCountries: [Country]?
    try store.store(cache)
    sut.load { result in
      loadedCountries = try? result.get()
      exp.fulfill()
    }
    
    wait(for: [exp], timeout: 1.0)
    XCTAssertEqual(loadedCountries, cachedCountries)
  }

  func test_load_insertsCache_onLoaderSuccess() throws {
    let date = Date()
    let (sut, loader, store) = makeSUT(date: { date })
    let exp = expectation(description: "Waiting for deliver")

    sut.load { _ in exp.fulfill() }
    let country = anyCountry()
    loader.complete(with: country)
    
    wait(for: [exp], timeout: 1.0)
    XCTAssertEqual(store.stored!.resource, [country])
    XCTAssertEqual(store.stored!.id, Int(date.timeIntervalSince1970))
  }
}

// MARK: - Private
private extension CountriesLoaderWithCachingTests {
  func makeSUT(date: @escaping (() -> Date) = Date.init,
               policy: @escaping ((_ : Date) -> Bool) = { _ in true }
  ) -> (CountriesLoaderWithCaching, CountriesLoaderMock, CountriesCacheStorageMock) {
    let loader = CountriesLoaderMock()
    let storage = CountriesCacheStorageMock()
    let sut = CountriesLoaderWithCaching(
      loader: loader,
      cacheLoader: ResourceCacheLoader(
        storage: (storage.load, storage.remove),
        date: date,
        policy: policy
      ),
      cacheCacher: ResourceCacheCacher(
        storage: storage.store,
        date: date
      )
    )
    
    return (sut, loader, storage)
  }
  
  class CountriesLoaderMock: CountriesLoader {
    var loadCalls = 0
    var completion: ((Result<[Country], Error>) -> Void)?
    
    func load(completion: @escaping (Result<[Country], Error>) -> Void) {
      loadCalls += 1
      self.completion = completion
    }
    
    func complete(with country: Country) {
      completion?(.success([country]))
    }
    
    func completeWithError() {
      completion?(.failure(NSError(domain: "", code: 1, userInfo: [:])))
    }
  }
  
  class CountriesCacheStorageMock: CountriesCacheStorage {
    var stored: ResourceCache<[Country]>?
    var removeCalls: Int = 0
    var storeCalls: Int = 0
    var loadCalls: Int = 0
    
    func store(_ cache: ResourceCache<[Country]>) throws {
      storeCalls += 1
      stored = cache
    }
    
    func remove(_ cache: ResourceCache<[Country]>) throws {
      removeCalls += 1
      stored = nil
    }
    
    func load() -> [ResourceCache<[Country]>] {
      loadCalls += 1
      guard let stored = stored else { return [] }
      return [stored]
    }
  }
}

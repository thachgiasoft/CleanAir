//
//  CitiesLoaderWithStorageValidationTests.swift
//  CleanAirModulesTests
//
//  Created by Marko Engelman on 23/11/2020.
//

import XCTest
@testable import CleanAirModules

class CitiesLoaderWithStorageValidationTests: XCTestCase {
  func test_init_doesntHaveSideEffects_onLoaderAndStorage() {
    let (_, loader, storage) = makeSUT()
    XCTAssertNil(loader.completion)
    XCTAssertTrue(storage.stored.isEmpty)
  }
  
  func test_load_eventuallyDeliversResult() {
    let (sut, loader, _) = makeSUT()
    let exp = expectation(description: "Waiting for deliver")
    sut.load { _ in
      exp.fulfill()
    }
    loader.complete(with: anyCity())
    wait(for: [exp], timeout: 1.0)
  }
  
  func test_load_hasNoSideEffectOnStore_onLoaderError() {
    let (sut, loader, store) = makeSUT()
    let exp = expectation(description: "Waiting for deliver")
    sut.load { _ in
      exp.fulfill()
    }
    loader.completeWithError()
    wait(for: [exp], timeout: 1.0)
    XCTAssertEqual(store.storeCalls, .zero)
    XCTAssertEqual(store.removeCalls, .zero)
  }
}

// MARK: - Private
private extension CitiesLoaderWithStorageValidationTests {
  func makeSUT() -> (CitiesLoaderWithStorageValidation, CityLoaderMock, CityStorageMock) {
    let loader = CityLoaderMock()
    let storage = CityStorageMock()
    let sut = CitiesLoaderWithStorageValidation(
      loader: loader,
      storage: storage
    )
    return (sut, loader, storage)
  }
  
  class CityLoaderMock: CitiesLoader {
    var completion: ((Result<[City], Error>) -> Void)?
    
    func load(completion: @escaping (Result<[City], Error>) -> Void) {
      self.completion = completion
    }
    
    func complete(with city: City) {
      completion?(.success([city]))
    }
    
    func completeWithError() {
      completion?(.failure(NSError(domain: "", code: 1, userInfo: [:])))
    }
  }
  
  class CityStorageMock: CityStorage {
    var stored: [String: City] = [:]
    var removeCalls: Int = 0
    var storeCalls: Int = 0
    
    func store(_ object: City, completion: @escaping (StoreResult) -> Void) {
      storeCalls += 1
      stored[object.id] = object
    }
    
    func load() -> [City]? {
      return stored.map { $0.value }
    }
    
    func load(objectId: Any) -> City? {
      return stored[objectId as! String]
    }
    
    func remove(objectId: Any, completion: @escaping (RemoveResult) -> Void) {
      removeCalls += 1
      stored.removeValue(forKey: objectId as! String)
      completion(.success(()))
    }
  }
}

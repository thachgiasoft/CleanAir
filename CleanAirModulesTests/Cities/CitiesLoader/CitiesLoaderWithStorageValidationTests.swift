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
    XCTAssertNil(storage.stored)
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
  
  func test_load_updatesWithLocalData_onLoaderSuccess() throws {
    let (sut, loader, store) = makeSUT()
    let exp = expectation(description: "Waiting for deliver")
    
    let localIsFavourite = true
    try store.store(anyCity(isFavourite: localIsFavourite))

    var loadedCity: City!
    sut.load { result in
      loadedCity = try! result.get().first
      exp.fulfill()
    }
    loader.complete(with: anyCity(isFavourite: !localIsFavourite))
    wait(for: [exp], timeout: 1.0)
    XCTAssertEqual(loadedCity.isFavourite, localIsFavourite)
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
    var stored: City?
    var removeCalls: Int = 0
    var storeCalls: Int = 0
    var loadCalls: Int = 0
    var getAllCalls: Int = 0
    
    func store(_ object: City) throws {
      storeCalls += 1
      stored = object
    }
    
    func load() -> [City]? {
      getAllCalls += 1
      return [stored].compactMap { $0 }
    }
    
    func load(objectId: Any) -> City? {
      loadCalls += 1
      return stored
    }
    
    func remove(objectId: Any, completion: @escaping (RemoveResult) -> Void) {
      removeCalls += 1
      completion(.success(()))
    }
  }
}

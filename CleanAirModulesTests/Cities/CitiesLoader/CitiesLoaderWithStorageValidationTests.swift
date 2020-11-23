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
  }
  
  class CityStorageMock: CityStorage {
    var stored: [String: City] = [:]
    
    func store(_ object: City, completion: @escaping (StoreResult) -> Void) {
      stored[object.id] = object
    }
    
    func load() -> [City]? {
      return stored.map { $0.value }
    }
    
    func load(objectId: Any) -> City? {
      return stored[objectId as! String]
    }
    
    func remove(objectId: Any, completion: @escaping (RemoveResult) -> Void) {
      stored.removeValue(forKey: objectId as! String)
      completion(.success(()))
    }
  }
}

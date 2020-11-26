//
//  ResourceStorageResultObserverTests.swift
//  CleanAirModulesTests
//
//  Created by Marko Engelman on 26/11/2020.
//

import XCTest
@testable import CleanAirModules
@testable import RealmSwift

class ResourceStorageResultObserverTests: XCTestCase {
  override class func setUp() {
    preapareForTesting()
  }
  
  func test_insertions_triggersInsertedResource() throws {
    let currentLocal = self.local(for: "!", id: UUID().uuidString)
    let insertion = self.local(for: currentLocal.queryValue, id: UUID().uuidString)
    let (sut, storage) = makeSUT(for: currentLocal)
    
    let exp = expectation(description: "Waiting for insertion notification")
    sut.inserted = {
      XCTAssertEqual($0.1, [currentLocal.queryValue])
      exp.fulfill()
    }
    try storage.insert(object: insertion)
    
    wait(for: [exp], timeout: 1.0)
  }
  
  func test_deletions_triggersDeletedResource() throws {
    let currentLocal = self.local(for: "!", id: UUID().uuidString)
    let (sut, storage) = makeSUT(for: currentLocal)
    try storage.insert(object: currentLocal)
    
    let exp = expectation(description: "Waiting for deletion notification")
    sut.removed = {
      XCTAssertEqual($0.1, [])
      exp.fulfill()
    }
    
    try storage.delete(object: type(of: currentLocal), forId: currentLocal.id)
    
    wait(for: [exp], timeout: 1.0)
  }
}

// MARK: - Private
private extension ResourceStorageResultObserverTests {
  func makeSUT(for local: AnyLocalType) -> (ResourceStorageResultObserver<AnyType, AnyLocalType>, RealmStorage) {
    let storage = RealmStorage(realm: self.realm)
    let result = storage.find(object: type(of: local), filtered: self.anyLocalFilter(for: local))
    let observer = RealmStorageResultObserver(result: result)
    
    let sut = ResourceStorageResultObserver<AnyType, AnyLocalType>(
      observer: observer,
      mapper: { _ in local.queryValue }
    )
    
    return (sut, storage)
  }
}


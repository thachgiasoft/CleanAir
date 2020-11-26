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
    let currentLocal = Self.local(for: "!", id: UUID().uuidString)
    let insertion = Self.local(for: currentLocal.queryValue, id: UUID().uuidString)
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
    let currentLocal = Self.local(for: "!", id: UUID().uuidString)
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
    let storage = RealmStorage(realm: { try! Realm() })
    let result = storage.find(object: type(of: local), filtered: Self.anyLocalFilter(for: local))
    let observer = RealmStorageResultObserver(result: result)
    
    let sut = ResourceStorageResultObserver<AnyType, AnyLocalType>(
      observer: observer,
      mapper: { _ in local.queryValue }
    )
    
    return (sut, storage)
  }
  
  static func preapareForTesting() {
    Realm.Configuration.defaultConfiguration.deleteRealmIfMigrationNeeded = true
    Realm.Configuration.defaultConfiguration.inMemoryIdentifier = UUID().uuidString
  }
  
  static func local(for value: AnyType, id: String) -> AnyLocalType {
    let local = AnyLocalType()
    local.id = id
    local.queryValue = value
    return local
  }
  
  static func anyLocalFilter(for value: AnyLocalType) -> NSPredicate {
    return NSPredicate(format: "queryValue == %@", value.queryValue)
  }
}


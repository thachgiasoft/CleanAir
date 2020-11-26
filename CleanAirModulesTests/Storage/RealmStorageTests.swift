//
//  StorageTests.swift
//  CleanAirModulesTests
//
//  Created by Marko Engelman on 22/11/2020.
//

import XCTest
@testable import CleanAirModules
@testable import RealmSwift

class RealmStorageTests: XCTestCase {
  override class func setUp() {
    preapareForTesting()
  }
  
  func test_insert_doesntThrowError() {
    let sut = makeSUT()
    XCTAssertNoThrow(try sut.insert(object: anyLocal))
  }
  
  func test_find_deliversEmptyOnEmptyStore() {
    let sut = makeSUT()
    XCTAssertTrue(sut.find(object: type(of: anyLocal)).isEmpty)
  }
  
  func test_load_deliversStoredResult() throws {
    let local = anyLocal
    let sut = makeSUT()
    try sut.insert(object: local)
    XCTAssertTrue(sut.find(object: type(of: local)).first == local)
  }
  
  func test_load_deliversQueriedResult() throws {
    let local = anyLocal
    let sut = makeSUT()
    try sut.insert(object: local)
    let existingValues = sut
      .find(object: type(of: local),
            filtered: NSPredicate(format: "queryValue = %@", local.queryValue)
      )
    
    let nonExistingValues = sut
      .find(object: type(of: local),
            filtered: NSPredicate(format: "queryValue = %@", anyLocal.queryValue)
      )
    
    XCTAssertFalse(existingValues.isEmpty)
    XCTAssertTrue(nonExistingValues.isEmpty)
  }
  
  func test_loadForId_deliversStoredResult() throws {
    let local = anyLocal
    let sut = makeSUT()
    try sut.insert(object: local)
    XCTAssertEqual(sut.find(object: type(of: local), forId: local.id), local)
  }
  
  func test_removeExistingObject_doesntThrowError() throws {
    let local = anyLocal
    let sut = makeSUT()
    try sut.insert(object: local)
    XCTAssertNoThrow(try sut.delete(object: type(of: local), forId: local.id))
  }
  
  func test_removeUnexistingObject_ThrowsError() throws {
    let local = anyLocal
    let sut = makeSUT()
    XCTAssertThrowsError(try sut.delete(object: type(of: local), forId: local.id))
  }
}

// MARK: - Private
private extension RealmStorageTests {
  func makeSUT() -> RealmStorage {
    let sut = RealmStorage(realm: { try! Realm(configuration: .defaultConfiguration) })
    return sut
  }
  
  static func preapareForTesting() {
    Realm.Configuration.defaultConfiguration.deleteRealmIfMigrationNeeded = true
    Realm.Configuration.defaultConfiguration.inMemoryIdentifier = UUID().uuidString
  }
  
  static func local(for value: AnyType) -> AnyLocalType {
    let local = AnyLocalType()
    local.id = value
    local.queryValue = value
    return local
  }
  
  var anyLocal: AnyLocalType {
    return Self.local(for: anyResource)
  }
}

class AnyLocalType: Object {
  @objc dynamic var id = ""
  @objc dynamic var queryValue = ""
  
  override class func primaryKey() -> String? {
    return "id"
  }
}

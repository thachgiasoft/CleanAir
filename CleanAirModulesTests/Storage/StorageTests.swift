//
//  StorageTests.swift
//  CleanAirModulesTests
//
//  Created by Marko Engelman on 22/11/2020.
//

import XCTest
@testable import CleanAirModules
@testable import RealmSwift

class StorageTests: XCTestCase {
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
private extension StorageTests {
  func makeSUT() -> RealmStorage<AnyType, AnyLocalType> {
    let sut = RealmStorage(
      realm: { try! Realm(configuration: .defaultConfiguration) },
      storeMapper: { Self.local(for: $0) },
      objectMapper: { $0.id }
    )
    return sut
  }
  
  static func preapareForTesting() {
    Realm.Configuration.defaultConfiguration.inMemoryIdentifier = UUID().uuidString
  }
  
  static func local(for value: AnyType) -> AnyLocalType {
      let local = AnyLocalType()
      local.id = value
      return local
  }
  
  var anyLocal: AnyLocalType {
    return Self.local(for: anyResource)
  }
}

class AnyLocalType: Object {
  @objc dynamic var id = ""
  override class func primaryKey() -> String? {
    return "id"
  }
}

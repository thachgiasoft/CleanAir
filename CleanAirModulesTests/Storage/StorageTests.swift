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
  static var realm: Realm = try! Realm()
  
  override class func setUp() {
    preapareForTesting()
  }
  
  func test_store_doesntThrowError() {
    let resource: AnyType = 1
    let sut = makeSUT()
    XCTAssertNoThrow(try sut.store(resource))
  }
  
  func test_load_deliversStoredResult() throws {
    let resource: AnyType = 2
    let sut = makeSUT()
    try sut.store(resource)
    XCTAssertTrue(sut.load()!.contains(resource))
  }
  
  func test_loadForId_deliversStoredResult() throws {
    let resource: AnyType = 3
    let sut = makeSUT()
    try sut.store(resource)
    XCTAssertEqual(sut.load(objectId: resource), resource)
  }
  
  func test_removeExistingObject_doesntThrowError() throws {
    let resource: AnyType = 3
    let sut = makeSUT()
    try sut.store(resource)
    XCTAssertNoThrow(try sut.remove(objectId: resource))
  }
  
  func test_removeUnexistingObject_ThrowsError() throws {
    let resource: AnyType = 4
    let sut = makeSUT()
    try sut.store(resource)
    XCTAssertThrowsError(try sut.remove(objectId: 5))
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
    Realm.Configuration.defaultConfiguration.inMemoryIdentifier = "inMemoryRealm"
  }
  
  static func local(for value: AnyType) -> AnyLocalType {
    let local = AnyLocalType()
    local.id = value
    return local
  }
}

class AnyLocalType: Object {
  @objc dynamic var id: AnyType = 0
  override class func primaryKey() -> String? {
    return "id"
  }
}
typealias AnyType = Int

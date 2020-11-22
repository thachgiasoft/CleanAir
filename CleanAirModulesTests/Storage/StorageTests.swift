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
  
  func test_init_storesRealmInstance() {
    let sut = makeSUT()
    XCTAssertEqual(sut.realm, Self.realm)
  }
  
  func test_store_doesntThrowError() {
    let resource: AnyType = 1
    let sut = makeSUT()
    XCTAssertNoThrow(try sut.store(resource))
  }
}

// MARK: - Private
private extension StorageTests {
  func makeSUT() -> RealmStorage<AnyType, AnyLocalType> {
    let sut = RealmStorage(
      realm: Self.realm,
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

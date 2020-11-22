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
}

// MARK: - Private
private extension StorageTests {
  class AnyLocalType: Object {
    @objc dynamic var id: AnyType = 0
    override class func primaryKey() -> String? {
      return "id"
    }
  }
  typealias AnyType = Int
  
  func makeSUT() -> RealmStorage<AnyType, AnyLocalType> {
    let realm = try! Realm(configuration: .defaultConfiguration)
    let sut = RealmStorage(
      realm: realm,
      storeMapper: { AnyLocalType(value: $0) },
      objectMapper: { $0.id }
    )
    return sut
  }
  
  static func preapareForTesting() {
    Realm.Configuration.defaultConfiguration.inMemoryIdentifier = "inMemoryRealm"
  }
}

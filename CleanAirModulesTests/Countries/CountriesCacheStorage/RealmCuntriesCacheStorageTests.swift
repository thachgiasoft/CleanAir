//
//  RealmCuntriesCacheStorageTests.swift
//  CleanAirModulesTests
//
//  Created by Marko Engelman on 25/11/2020.
//

import XCTest
@testable import CleanAirModules
@testable import RealmSwift

class RealmCuntriesCacheStorageTests: XCTestCase {
  override class func setUp() {
    preapareForTesting()
  }

  func test_store_insertsCache() throws {
    let sut = makeSUT()
    XCTAssertNoThrow(try sut.store(anyCountriesCache()))
  }

  func test_load_loads_insertedCache() throws {
    let sut = makeSUT()
    let cache = anyCountriesCache()
    try sut.store(cache)
    XCTAssertEqual(sut.load(), [cache])
  }

  func test_remove_removes_insertedCache() throws {
    let sut = makeSUT()
    let cache = anyCountriesCache()
    try sut.store(cache)
    XCTAssertNoThrow(try sut.remove(cache))
  }
}

// MARK: - Private
private extension RealmCuntriesCacheStorageTests {
  func makeSUT() -> CountriesCacheStorage {
    let sut = RealmStorage(realm: { try! Realm(configuration: .defaultConfiguration) })
    return sut
  }
  
  static func preapareForTesting() {
    Realm.Configuration.defaultConfiguration.deleteRealmIfMigrationNeeded = true
    Realm.Configuration.defaultConfiguration.inMemoryIdentifier = UUID().uuidString
  }
}

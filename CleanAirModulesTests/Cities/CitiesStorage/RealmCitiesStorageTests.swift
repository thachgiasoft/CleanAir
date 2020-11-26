//
//  RealmCitiesStorageTests.swift
//  CleanAirModulesTests
//
//  Created by Marko Engelman on 25/11/2020.
//

import XCTest
@testable import CleanAirModules
@testable import RealmSwift

class RealmCitiesStorageTests: XCTestCase {
  override class func setUp() {
    preapareForTesting()
  }

  func test_store_insertsCity() throws {
    let sut = makeSUT()
    XCTAssertNoThrow(try sut.store(anyCity()))
  }
  
  func test_load_loads_insertedCity() throws {
    let sut = makeSUT()
    let city = anyCity()
    try sut.store(city)
    XCTAssertNotNil(sut.load(cityId: city.id))
  }
  
  func test_load_loads_requestsCities() throws {
    let sut = makeSUT()
    let favourite = true
    let city = anyCity(isFavourite: favourite)
    try sut.store(city)
    let request = CityStorageLoadRequest(isFavourite: favourite)
    XCTAssertFalse(sut.load(with: request).isEmpty)
  }
  
  func test_remove_removes_insertedCity() throws {
    let sut = makeSUT()
    let city = anyCity()
    try sut.store(city)
    XCTAssertNoThrow(try sut.remove(cityId: city.id))
  }
  
  func test_remove_throwsError_forNonExistingCity() throws {
    let sut = makeSUT()
    try sut.store(anyCity())
    XCTAssertThrowsError(try sut.remove(cityId: anyCity().id))
  }
}

// MARK: - Private
private extension RealmCitiesStorageTests {
  func makeSUT() -> CityStorage {
    let sut = RealmStorage(realm: { try! Realm(configuration: .defaultConfiguration) })
    return sut
  }
  
  static func preapareForTesting() {
    Realm.Configuration.defaultConfiguration.inMemoryIdentifier = UUID().uuidString
  }
}

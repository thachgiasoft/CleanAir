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
  
  func test_store_doesntThrowError() {
    XCTAssertNoThrow(try makeSUT().store(anyResource))
  }
  
  func test_load_deliversEmptyOnEmptyStore() {
    let sut = makeSUT()
    XCTAssertTrue(sut.load()!.isEmpty)
  }
  
  func test_load_deliversStoredResult() throws {
    let resource = anyResource
    let sut = makeSUT()
    try sut.store(resource)
    XCTAssertTrue(sut.load() == [resource])
  }
  
  func test_loadForId_deliversStoredResult() throws {
    let resource = anyResource
    let sut = makeSUT()
    try sut.store(resource)
    XCTAssertEqual(sut.load(objectId: resource), resource)
  }
  
  func test_removeExistingObject_doesntThrowError() throws {
    let resource = anyResource
    let sut = makeSUT()
    
    try sut.store(resource)
    
    let exp2 = expectation(description: "Waiting to store")
    var receivedResult: Swift.Result<Void, Error>?
    sut.remove(objectId: resource) { result in
      receivedResult = result
      exp2.fulfill()
    }
    wait(for: [exp2], timeout: 1.0)
    XCTAssertNoThrow(try receivedResult?.get())
  }
  
  func test_removeUnexistingObject_ThrowsError() throws {
    let resource = anyResource
    let sut = makeSUT()
    try sut.store(resource)
    
    let exp2 = expectation(description: "Waiting to store")
    var receivedResult: Swift.Result<Void, Error>?
    sut.remove(objectId: anyResource) { result in
      receivedResult = result
      exp2.fulfill()
    }
    wait(for: [exp2], timeout: 1.0)
    XCTAssertThrowsError(try receivedResult?.get())
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
}

class AnyLocalType: Object {
  @objc dynamic var id = ""
  override class func primaryKey() -> String? {
    return "id"
  }
}

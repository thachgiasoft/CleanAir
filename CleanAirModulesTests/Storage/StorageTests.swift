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
    let resource: AnyType = 1
    let sut = makeSUT()
    let exp = expectation(description: "Waiting to store")
    var result: Swift.Result<Void, Error>?
    sut.store(resource) { receivedResult in
      result = receivedResult
      exp.fulfill()
    }
    
    wait(for: [exp], timeout: 1.0)
    XCTAssertNoThrow(try result?.get())
  }
  
  func test_load_deliversEmptyOnEmptyStore() {
    let sut = makeSUT()
    XCTAssertTrue(sut.load()!.isEmpty)
  }
  
  func test_load_deliversStoredResult() throws {
    let resource: AnyType = 2
    let sut = makeSUT()
    let exp = expectation(description: "Waiting to store")
    sut.store(resource) { _ in
      exp.fulfill()
    }
    
    wait(for: [exp], timeout: 1.0)
    XCTAssertTrue(sut.load() == [resource])
  }
  
  func test_loadForId_deliversStoredResult() throws {
    let resource: AnyType = 3
    let sut = makeSUT()
    
    let exp = expectation(description: "Waiting to store")
    sut.store(resource) { _ in
      exp.fulfill()
    }
    
    wait(for: [exp], timeout: 1.0)
    XCTAssertEqual(sut.load(objectId: resource), resource)
  }
  
  func test_removeExistingObject_doesntThrowError() throws {
    let resource: AnyType = 4
    let sut = makeSUT()
    
    let exp1 = expectation(description: "Waiting to store")
    sut.store(resource) { _ in
      exp1.fulfill()
    }
    
    let exp2 = expectation(description: "Waiting to store")
    var receivedResult: Swift.Result<Void, Error>?
    sut.remove(objectId: resource) { result in
      receivedResult = result
      exp2.fulfill()
    }
    wait(for: [exp1, exp2], timeout: 1.0)
    XCTAssertNoThrow(try receivedResult?.get())
  }
  
  func test_removeUnexistingObject_ThrowsError() throws {
    let resource: AnyType = 5
    let sut = makeSUT()
    let exp1 = expectation(description: "Waiting to store")
    sut.store(resource) { _ in
      exp1.fulfill()
    }
    
    let exp2 = expectation(description: "Waiting to store")
    var receivedResult: Swift.Result<Void, Error>?
    sut.remove(objectId: 6) { result in
      receivedResult = result
      exp2.fulfill()
    }
    wait(for: [exp1, exp2], timeout: 1.0)
    XCTAssertThrowsError(try receivedResult?.get())
  }
  
  func test_multipleQueues_haveNoSideEffects() throws {
    let q1 = DispatchQueue(label: "1", qos: .background)
    let q2 = DispatchQueue(label: "2", qos: .utility)
    let q3 = DispatchQueue(label: "3", qos: .userInteractive)
    let q4 = DispatchQueue(label: "4", qos: .default)
    
    let exp1 = expectation(description: "q1")
    let exp2 = expectation(description: "q2")
    let exp3 = expectation(description: "q3")
    let exp4 = expectation(description: "q4")
    
    let sut = makeSUT()
    XCTAssertNil(sut.load(objectId: 11))
    
    q1.async { sut.store(1) { _ in exp1.fulfill() }}
    q2.async { sut.remove(objectId: 11) { _ in exp2.fulfill() }}
    q3.async { sut.store(1) { _ in exp3.fulfill() } }
    q4.async { sut.remove(objectId: 11) { _ in exp4.fulfill() }}
    
    wait(for: [exp1, exp2, exp3, exp4], timeout: 1.0)
    
    XCTAssertNil(sut.load(objectId: 11))
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
  @objc dynamic var id: AnyType = 0
  override class func primaryKey() -> String? {
    return "id"
  }
}
typealias AnyType = Int

//
//  RealmStorageResultObserverTests.swift
//  CleanAirModulesTests
//
//  Created by Marko Engelman on 26/11/2020.
//

import XCTest
@testable import CleanAirModules
@testable import RealmSwift

class RealmStorageResultObserverTests: XCTestCase {
  override class func setUp() {
    preapareForTesting()
  }
  
  func test_insertions_deliversInsertedObjectForQuery() throws {
    let currentLocal = self.local(for: "!", id: UUID().uuidString)
    let insertion = self.local(for: currentLocal.queryValue, id: UUID().uuidString)
    let preQueryStorageValues = [currentLocal, self.local(for: currentLocal.queryValue, id: UUID().uuidString)]

    let (sut, storage) = try makeSut(for: currentLocal, with: preQueryStorageValues)

    let exp = expectation(description: "Waiting for insertion notification")

    var inserted: [AnyLocalType] = []
    sut.inserted = {
      inserted = $0.updatedLoadResult
      exp.fulfill()
    }

    try storage.insert(object: insertion)

    wait(for: [exp], timeout: 1.0)
    
    let final = ([insertion] + preQueryStorageValues)
    final.forEach { XCTAssertTrue(inserted.contains($0)) }
    XCTAssertEqual(final.count, inserted.count)
  }
  
  func test_deletion_deliversRemovedObjectForQuery() throws {
    let currentLocal = self.local(for: "!", id: UUID().uuidString)
    let deletion = self.local(for: currentLocal.queryValue, id: UUID().uuidString)
    let preQueryStorageValues = [deletion, currentLocal, self.local(for: currentLocal.queryValue, id: UUID().uuidString)]

    let (sut, storage) = try makeSut(for: currentLocal, with: preQueryStorageValues)

    let exp = expectation(description: "Waiting for deletion notification")

    var deleted: [AnyLocalType] = []
    sut.removed = {
      deleted = Array($0.updatedLoadResult)
      exp.fulfill()
    }

    try storage.delete(object: type(of: deletion), forId: deletion.id)
    var final = preQueryStorageValues
    final.remove(at: .zero)
    
    wait(for: [exp], timeout: 1.0)
    deleted.forEach { XCTAssertTrue(final.contains($0)) }
    XCTAssertEqual(final.count, deleted.count)
  }
}

// MARK: - Private
private extension RealmStorageResultObserverTests {
  func makeSut(
    for local: AnyLocalType,
    with initial: [AnyLocalType]) throws -> (RealmStorageResultObserver<AnyLocalType>, RealmStorage) {
    let storage = RealmStorage(realm: self.realm)
    initial.forEach { try! storage.insert(object: $0) }
    let result = storage.find(object: type(of: local), filtered: self.anyLocalFilter(for: local))
    let sut = RealmStorageResultObserver(result: result)
    return (sut, storage)
  }
}

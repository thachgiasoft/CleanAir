//
//  RealmStorageTests+Helpers.swift
//  CleanAirModulesTests
//
//  Created by Marko Engelman on 26/11/2020.
//

import XCTest
@testable import CleanAirModules
@testable import RealmSwift

class AnyLocalType: Object {
  @objc dynamic var id = ""
  @objc dynamic var queryValue = ""
  
  override class func primaryKey() -> String? {
    return "id"
  }
}

extension XCTestCase {
  var anyLocal: AnyLocalType {
    return local(for: anyResource)
  }
  
  func local(for value: AnyType, id: String = UUID().uuidString) -> AnyLocalType {
    let local = AnyLocalType()
    local.id = id
    local.queryValue = value
    return local
  }
  
  static func preapareForTesting() {
    Realm.Configuration.defaultConfiguration.deleteRealmIfMigrationNeeded = true
    Realm.Configuration.defaultConfiguration.inMemoryIdentifier = UUID().uuidString
  }
  
  func realm() -> Realm {
    return try! Realm()
  }
  
  func anyLocalFilter(for value: AnyLocalType) -> NSPredicate {
    return NSPredicate(format: "queryValue == %@", value.queryValue)
  }
}

//
//  RealmStorage.swift
//  CleanAirModules
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation
import RealmSwift

public class RealmStorage<LocalObject, RealmObject> where RealmObject: Object {
  public typealias StoreMapper = (LocalObject) -> RealmObject
  public typealias ResultMappper = (Results<RealmObject>) -> [LocalObject]
  public typealias ObjectMapper = (RealmObject) -> LocalObject
  
  let realm: Realm
  let storeMapper: StoreMapper
  let resultMapper: ResultMappper
  let objectMapper: ObjectMapper
  
  enum StorageError: Swift.Error {
    case objectNotFound
  }
  
  public init(realm: Realm,
              storeMapper: @escaping StoreMapper,
              objectMapper: @escaping ObjectMapper) {
    self.realm = realm
    self.storeMapper = storeMapper
    self.resultMapper = { result in return result.map { objectMapper($0) } }
    self.objectMapper = objectMapper
  }
}

// MARK: - Storage
extension RealmStorage: Storage {
  public func store(_ object: LocalObject) throws {
    try realm.write {
      realm.add(storeMapper(object), update: .all)
    }
  }
  
  public func load() -> [LocalObject]? {
    let result = realm.objects(RealmObject.self)
    return resultMapper(result)
  }
  
  public func load(objectId: Any) -> LocalObject? {
    guard let result = realm.object(ofType: RealmObject.self, forPrimaryKey: objectId) else { return .none }
    return objectMapper(result)
  }
  
  public func remove(objectId: Any) throws {
    guard let result = realm.object(ofType: RealmObject.self, forPrimaryKey: objectId) else { throw StorageError.objectNotFound }
    try realm.write {
      realm.delete(result)
    }
  }
}

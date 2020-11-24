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
  
  let realmIntializer: () -> Realm
  let storeMapper: StoreMapper
  let resultMapper: ResultMappper
  let objectMapper: ObjectMapper
  lazy var queue = DispatchQueue(label: "\(self)")
  
  enum StorageError: Swift.Error {
    case objectNotFound
  }
  
  public init(realm: @escaping () -> Realm,
              storeMapper: @escaping StoreMapper,
              objectMapper: @escaping ObjectMapper) {
    self.realmIntializer = realm
    self.storeMapper = storeMapper
    self.resultMapper = { result in return result.map { objectMapper($0) } }
    self.objectMapper = objectMapper
  }
  
  func find<T: Object>(object: T.Type) -> Results<T> {
    let realm = realmIntializer()
    let result = realm.objects(T.self)
    return result
  }
  
  func find<T: Object>(object: T.Type, forId: Any) -> T? {
    let realm = realmIntializer()
    return realm.object(ofType: T.self, forPrimaryKey: forId)
  }
  
  func insert<T: Object>(object: T, update: Realm.UpdatePolicy = .all) throws {
    let realm = self.realmIntializer()
    do {
      try realm.write {
        realm.add(object, update: update)
      }
    } catch {
      throw error
    }
  }
  
  func delete<T: Object>(object: T.Type, forId: Any) throws {
    let realm = self.realmIntializer()
    guard let result = realm.object(ofType: object, forPrimaryKey: forId) else { throw StorageError.objectNotFound }
    do {
      try realm.write {
        realm.delete(result)
      }
    } catch {
      throw error
    }
  }
}

// MARK: - Storage
extension RealmStorage: Storage {
  public func store(_ object: LocalObject) throws {
    try insert(object: self.storeMapper(object))
  }
  
  public func remove(objectId: Any) throws {
    try delete(object: RealmObject.self, forId: objectId)
  }
  
  public func load() -> [LocalObject]? {
    return resultMapper(find(object: RealmObject.self))
  }
  
  public func load(objectId: Any) -> LocalObject? {
    guard let object = find(object: RealmObject.self, forId: objectId) else { return .none }
    return objectMapper(object)
  }
}

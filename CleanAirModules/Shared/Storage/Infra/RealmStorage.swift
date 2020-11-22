//
//  RealmStorage.swift
//  CleanAirModules
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation
import RealmSwift

public class RealmStorage<StoringObject, LoadingObject, RealmObject> where RealmObject: Object {
  public typealias StoreMapper = (StoringObject) -> RealmObject
  public typealias ResultMappper = (Results<RealmObject>) -> [LoadingObject]
  public typealias ObjectMapper = (RealmObject) -> LoadingObject
  
  let realm: Realm
  let storeMapper: StoreMapper
  let resultMapper: ResultMappper
  let objectMapper: ObjectMapper
  
  enum StorageError: Swift.Error {
    case objectNotFound
  }
  
  public init(realm: Realm,
              storeMapper: @escaping StoreMapper,
              objectMapper: @escaping ObjectMapper) where StoringObject == LoadingObject {
    self.realm = realm
    self.storeMapper = storeMapper
    self.resultMapper = { result in return result.map { objectMapper($0) } }
    self.objectMapper = objectMapper
  }
}

// MARK: - Storage
extension RealmStorage: Storage {
  public func store(_ object: StoringObject) throws {
    try realm.write {
      realm.add(storeMapper(object), update: .all)
    }
  }
  
  public func load() -> [LoadingObject]? {
    let result = realm.objects(RealmObject.self)
    return resultMapper(result)
  }
  
  public func load(objectId: Any) -> LoadingObject? {
    guard let result = realm.object(ofType: RealmObject.self, forPrimaryKey: objectId) else { return .none }
    return objectMapper(result)
  }
  
  public func remove(_ object: StoringObject) -> Storage.RemoveResult {
    do {
      try realm.write {
        realm.delete(storeMapper(object))
      }
      return .success(())
    } catch {
      return .failure(error)
    }
  }
  
  public func remove(objectId: Any) -> Storage.RemoveResult {
    do {
      guard let result = realm.object(ofType: RealmObject.self, forPrimaryKey: objectId) else { return .failure(StorageError.objectNotFound) }
      try realm.write {
        realm.delete(result)
      }
      return .success(())
    } catch {
      return .failure(error)
    }
  }
}

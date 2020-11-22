//
//  RealmStorage.swift
//  CleanAirModules
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation
import RealmSwift

public class RealmStorage<StoringObject, RealmObject> where RealmObject: Object {
  public typealias StoreMapper = (StoringObject) -> RealmObject
  public typealias ResultMappper = (Results<RealmObject>) throws -> StoringObject
  public typealias ObjectMapper = (RealmObject) throws -> StoringObject
  
  let storeMapper: StoreMapper
  let resultMapper: (Results<RealmObject>) throws -> StoringObject
  let objectMapper: (RealmObject) throws -> StoringObject
  
  enum StorageError: Swift.Error {
    case objectNotFound
  }
  
  public init(storeMapper: @escaping StoreMapper, resultMapper: @escaping ResultMappper) {
    self.storeMapper = storeMapper
    self.resultMapper = resultMapper
    self.objectMapper = { _ in throw StorageError.objectNotFound }
  }
  
  public init(storeMapper: @escaping StoreMapper, objectMapper: @escaping ObjectMapper) {
    self.storeMapper = storeMapper
    self.resultMapper = { _ in throw StorageError.objectNotFound }
    self.objectMapper = objectMapper
  }
}

// MARK: - Storage
extension RealmStorage: Storage {
  public func store(_ object: StoringObject) -> Storage.StoreResult {
    do {
      let realm = try Realm()
      try realm.write {
        realm.add(storeMapper(object), update: .all)
      }
      return .success(())
    } catch {
      return .failure(error)
    }
  }
  
  public func load() -> Swift.Result<StoringObject, Error> {
    do {
      let realm = try Realm()
      let result = realm.objects(RealmObject.self)
      let objects = try resultMapper(result)
      return .success(objects)
    } catch {
      return .failure(error)
    }
  }
  
  public func load(objectId: Any) -> Swift.Result<StoringObject, Error> {
    do {
      let realm = try Realm()
      guard let result = realm.object(ofType: RealmObject.self, forPrimaryKey: objectId) else { return .failure(StorageError.objectNotFound) }
      let loadResult = try objectMapper(result)
      return .success(loadResult)
    } catch {
      return .failure(error)
    }
  }
  
  public func remove(_ object: StoringObject) -> Storage.RemoveResult {
    do {
      let realm = try Realm()
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
      let realm = try Realm()
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

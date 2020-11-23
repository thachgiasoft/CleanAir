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
}

// MARK: - Storage
extension RealmStorage: Storage {
  public func store(_ object: LocalObject) throws {
    let realm = self.realmIntializer()
    do {
      try realm.write {
        realm.add(self.storeMapper(object), update: .all)
      }
    } catch {
      throw error
    }
  }
  
  public func remove(objectId: Any, completion: @escaping (RemoveResult) -> Void) {
    queue.async(flags: .barrier) { [weak self] in
      guard let self = self else { return }
      let realm = self.realmIntializer()
      guard let result = realm.object(ofType: RealmObject.self, forPrimaryKey: objectId) else { return completion(.failure(StorageError.objectNotFound))}
      do {
        try realm.write {
          realm.delete(result)
          completion(.success(()))
        }
      } catch {
        completion(.failure(error))
      }
    }
  }
  
  public func load() -> [LocalObject]? {
    let realm = self.realmIntializer()
    var result: Results<RealmObject>?
    queue.sync { result = realm.objects(RealmObject.self) }
    guard let unwrapped = result else { return .none }
    return resultMapper(unwrapped)
  }
  
  public func load(objectId: Any) -> LocalObject? {
    var result: RealmObject?
    let realm = realmIntializer()
    queue.sync { result = realm.object(ofType: RealmObject.self, forPrimaryKey: objectId) }
    guard let unwrapped = result else { return .none }
    return objectMapper(unwrapped)
  }
}

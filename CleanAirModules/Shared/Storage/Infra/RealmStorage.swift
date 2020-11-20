//
//  RealmStorage.swift
//  CleanAirModules
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation
import RealmSwift

public class RealmStorage<StoringObject, RealmObject> where RealmObject: Object {
  let storeMapper: (StoringObject) -> RealmObject
  let loadMapper: (Results<RealmObject>) throws -> StoringObject
  
  public init(storeMapper: @escaping (StoringObject) -> RealmObject, loadMapper: @escaping (Results<RealmObject>) throws -> StoringObject) {
    self.storeMapper = storeMapper
    self.loadMapper = loadMapper
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
      let loadResult = try loadMapper(result)
      return .success(loadResult)
    } catch {
      return .failure(error)
    }
  }
}

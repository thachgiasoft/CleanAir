//
//  RealmStorage.swift
//  CleanAirModules
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation
import RealmSwift

public class RealmStorage {
  let realmIntializer: () -> Realm
  
  enum StorageError: Swift.Error {
    case objectNotFound
  }
  
  public init(realm: @escaping () -> Realm) {
    self.realmIntializer = realm
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
  
  func find<T: Object>(object: T.Type, filtered: NSPredicate) -> Results<T> {
    let realm = realmIntializer()
    return realm.objects(T.self).filter(filtered)
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

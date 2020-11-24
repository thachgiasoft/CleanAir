//
//  XCTest+Helpers.swift
//  CleanAirModulesTests
//
//  Created by Marko Engelman on 23/11/2020.
//

import Foundation
import XCTest
@testable import CleanAirModules

extension XCTest {
  typealias AnyType = String
  typealias AnyTypeCache = ResourceCache<AnyType>
  typealias AnyTypeStore = ResourceStorage
  typealias AnyTypeCacher = ResourceCacheLoader<AnyType, AnyTypeStore>
  
  var anyResource: String { UUID().uuidString }
  
  class ResourceStorage: Storage {
    var caches: [Int: AnyTypeCache] = [:]
    var cacheLoadCalls: Int = 0
    var cacheRemoveCalls: Int = 0
    var cacheCalls: Int { caches.count }
    
    func remove(objectId: Any) throws {
      if let id = objectId as? Int {
        caches.removeValue(forKey: id)
      }
      cacheRemoveCalls += 1
    }
    
    func store(_ object: AnyTypeCache) throws {
      caches[object.id] = object
    }
    
    func load() -> [AnyTypeCache]? {
      cacheLoadCalls += 1
      return caches.map { $0.value }
    }
    
    func load(objectId: Any) -> AnyTypeCache? {
      cacheLoadCalls += 1
      if let id = objectId as? Int {
        return caches[id]
      } else {
        return nil
      }
    }
  }
  
  func anyCity(isFavourite: Bool = false) -> City {
    let name = UUID().uuidString
    let country = UUID().uuidString
    return City(
      name: name,
      country: country,
      measurementsCount: 1,
      availableLocationsCount: 1,
      isFavourite: isFavourite
    )
  }
  
  func anyLocalCity(isFavourite: Bool = true) -> RealmCity {
    let name = UUID().uuidString
    let country = UUID().uuidString
    let city = RealmCity()
    city.name = name
    city.country = country
    city.availableLocationsCount = 2
    city.measurementsCount = 2
    city.isFavourite = isFavourite
    return city
  }
}

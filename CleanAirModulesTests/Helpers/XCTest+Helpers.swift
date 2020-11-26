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
  typealias AnyTypeCacher = ResourceCacheLoader<AnyType>
  
  var anyResource: String { UUID().uuidString }
  
  class ResourceStorage {
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
    
    func load() -> [AnyTypeCache] {
      cacheLoadCalls += 1
      return caches.map { $0.value }
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
      measurementsCount: Int.random(in: 0...99999),
      availableLocationsCount: Int.random(in: 0...99999),
      isFavourite: isFavourite
    )
  }
  
  func anyLocalCity(isFavourite: Bool = true) -> RealmCity {
    let name = UUID().uuidString
    let country = UUID().uuidString
    let city = RealmCity()
    city.name = name
    city.country = country
    city.availableLocationsCount = Int.random(in: 0...99999)
    city.measurementsCount = Int.random(in: 0...99999)
    city.isFavourite = isFavourite
    return city
  }
  
  func anyCountry() -> Country {
    let code = UUID().uuidString
    let name = UUID().uuidString
    return Country(
      code: code,
      name: name,
      totalNumberOfMeasurements: Int.random(in: 0...99999),
      numberOfMeasuredCities: Int.random(in: 0...99999),
      numberOfMeasuringLocations: Int.random(in: 0...99999)
    )
  }
  
  func anyCountriesCache(timestamp: Date = Date(), id: Int = Int.random(in: 0...99999)) -> ResourceCache<[Country]> {
    let county = anyCountry()
    return ResourceCache(
      id: id,
      timestamp: timestamp,
      resource: [county]
    )
  }
  
  func anyLocalCountry() -> RealmCountry {
    let realmCounty = RealmCountry()
    realmCounty.code = UUID().uuidString
    realmCounty.name = UUID().uuidString
    realmCounty.count = Int.random(in: 0...99999)
    realmCounty.locations = Int.random(in: 0...99999)
    realmCounty.cities = Int.random(in: 0...99999)
    return realmCounty
  }
  
  class CityStorageMock: CityStorage {
    var stored: City?
    var removeCalls: Int = 0
    var storeCalls: Int = 0
    var loadCalls: Int = 0
    var getAllCalls: Int = 0
    
    func store(_ object: City) throws {
      storeCalls += 1
      stored = object
    }
    
    func load() -> [City]? {
      getAllCalls += 1
      return [stored].compactMap { $0 }
    }
    
    func load(cityId: String) -> City? {
      loadCalls += 1
      return stored
    }
    
    func remove(cityId: String) throws {
      removeCalls += 1
    }
    
    func load(with request: CityStorageLoadRequest) -> [City] {
      return []
    }
  }
}

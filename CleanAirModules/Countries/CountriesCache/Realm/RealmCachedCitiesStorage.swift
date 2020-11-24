//
//  RealmCachedCitiesStorage.swift
//  CleanAirModules
//
//  Created by Marko Engelman on 24/11/2020.
//

import Foundation

extension RealmStorage: CachedCountriesStorage {
  public func store(_ cache: ResourceCache<[Country]>) throws {
    try insert(object: CountriesCasheMapper.map(cache))
  }
  
  public func remove(_ cache: ResourceCache<[Country]>) throws {
    try delete(object: LocalCountryCache.self, forId: cache.id)
  }
  
  public func load() -> [ResourceCache<[Country]>] {
    let local = find(object: LocalCountryCache.self)
    return local.map { CountriesCasheMapper.map($0) }
  }
}

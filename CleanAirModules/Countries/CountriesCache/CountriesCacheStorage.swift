//
//  CountriesCacheStorage.swift
//  CleanAirModules
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

public typealias CountriesCacheStorage = RealmStorage<ResourceCache<[Country]>, RealmCountryCache>

public protocol CachedCountriesStorage {
  func store(_ cache: ResourceCache<[Country]>) throws
  func remove(_ cache: ResourceCache<[Country]>) throws
  func load() -> [ResourceCache<[Country]>]
}

//
//  CountriesCacheStorage.swift
//  CleanAirModules
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

public protocol CountriesCacheStorage {
  func store(_ cache: ResourceCache<[Country]>) throws
  func remove(_ cache: ResourceCache<[Country]>) throws
  func load() -> [ResourceCache<[Country]>]
}

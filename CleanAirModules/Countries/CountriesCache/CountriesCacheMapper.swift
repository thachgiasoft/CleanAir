//
//  CountriesCacheMapper.swift
//  CleanAirModules
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

public final class CountriesCasheMapper {
  public static func map(_ cache: ResourceCache<[Country]>) -> RealmCountryCache {
    let localCache = RealmCountryCache()
    localCache.id = cache.id
    localCache.timestamp = cache.timestamp
    cache.resource.forEach { localCache.countries.append(CountriesStorageMapper.map($0)) }
    return localCache
  }
  
  public static func map(_ localCache: RealmCountryCache) -> ResourceCache<[Country]> {
    ResourceCache(
      id: localCache.id,
      timestamp: localCache.timestamp,
      resource: localCache.countries.map(CountriesStorageMapper.map)
    )
  }
}

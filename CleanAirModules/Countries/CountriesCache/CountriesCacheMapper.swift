//
//  CountriesCacheMapper.swift
//  CleanAirModules
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

public final class CountriesCasheMapper {
  public static func map(_ cache: ResourceCache<[Country]>) -> LocalCountryCache {
    let localCache = LocalCountryCache()
    localCache.timeStamp = cache.id
    cache.resource.forEach { localCache.countries.append(CountriesStorageMapper.map($0)) }
    return localCache
  }
  
  public static func map(_ localCache: LocalCountryCache) -> ResourceCache<[Country]> {
    ResourceCache(
      id: localCache.timeStamp,
      resource: localCache.countries.map(CountriesStorageMapper.map)
    )
  }
}

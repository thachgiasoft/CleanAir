//
//  CountriesCacheMapper.swift
//  CleanAirModules
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation
import RealmSwift

public final class CountriesCasheMapper {
  public enum CacheError: Swift.Error {
    case invalidCacheResult
  }
  
  public static func map(_ cache: ResourceCache<[Country]>) -> LocalCountryCache {
    let localCache = LocalCountryCache()
    localCache.timeStamp = cache.timestamp
    cache.resource.forEach { localCache.countries.append(CountriesStorageMapper.map($0)) }
    return localCache
  }
  
  public static func map(_ localCache: LocalCountryCache) -> ResourceCache<[Country]> {
    ResourceCache(
      timestamp: localCache.timeStamp,
      resource: localCache.countries.map(CountriesStorageMapper.map)
    )
  }
}

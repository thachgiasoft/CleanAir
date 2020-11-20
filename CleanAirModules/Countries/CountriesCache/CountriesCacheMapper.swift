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
  
  public static func map(_ localCache: Results<LocalCountryCache>) throws -> ResourceCache<[Country]> {
    guard let cache = localCache.first, localCache.count == 1 else { throw CacheError.invalidCacheResult }
    return ResourceCache(
      timestamp: cache.timeStamp,
      resource: cache.countries.map(CountriesStorageMapper.map)
    )
  }
}

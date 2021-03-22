//
//  CountriesComponentsComposer.swift
//  CleanAir
//
//  Created by Marko Engelman on 25/11/2020.
//

import Foundation
import CleanAirModules
import RealmSwift

final class CountriesComponentsComposer {
  static func countriesLoader(client: HTTPClient, realm: @escaping () -> Realm) -> CountriesLoader {
    let loader = ResourceLoader(
      client: client,
      url: APIURL.countries,
      mapper: ResourceResultsMapper(CountryMapper.map).map
    )
    
    let storage = RealmStorage(realm: realm)
    let cacher = ResourceCacheCacher(
      storage: (storage.store),
      date: Date.init
    )
    
    let cacheLoader = ResourceCacheLoader(
      storage: (load: storage.load, remove: storage.remove),
      date: Date.init,
      policy: { CountriesCachePolicy.validate(cacheTimeStamp: $0, against: Date()) }
    )
    
    let loaderWithCaching = CountriesLoaderWithCaching(
      loader: loader,
      cacheLoader: cacheLoader,
      cacheCacher: cacher
    )
    return loaderWithCaching
  }
}
extension ResourceLoader: CountriesLoader where Resource == [Country] { }

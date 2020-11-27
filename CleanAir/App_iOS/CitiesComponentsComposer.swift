//
//  CitiesComponentsComposer.swift
//  CleanAir
//
//  Created by Marko Engelman on 25/11/2020.
//

import Foundation
import CleanAirModules
import RealmSwift

final class CitiesComponentsComposer {
  static func countriesLoader(client: HTTPClient, storage: CityStorage, countryCode: String) -> CitiesLoader {
    let loader = ResourceLoader(
      client: client,
      url: APIURL.cities(for: countryCode),
      mapper: ResourceResultsMapper(CityMapper.map).map
    )
    
    let loaderWithValidation = CitiesLoaderWithStorageValidation(
      loader: loader,
      storage: storage
    )
    
    return loaderWithValidation
  }
  
  static func countriesFavouriteService(realm: @escaping () -> Realm) -> FavouriteCityService {
    let service = FavouriteCityService(storage: RealmStorage(realm: realm))
    return service
  }
  
  static func storage(realm: @escaping () -> Realm) -> CityStorage {
    return RealmStorage(realm: realm)
  }
}
extension ResourceLoader: CitiesLoader where Resource == [City] { }

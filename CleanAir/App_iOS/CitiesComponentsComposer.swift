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
  static func countriesLoader(client: HTTPClient, realm: @escaping () -> Realm, countryCode: String) -> CitiesLoader {
    let loader = ResourceLoader(
      client: client,
      url: APIURL.cities(for: countryCode),
      mapper: ResourceResultsMapper(CityMapper.map).map
    )
    
    let loaderWithValidation = CitiesLoaderWithStorageValidation(
      loader: loader,
      storage: RealmStorage(realm: { try! Realm() })
    )
    
    return loaderWithValidation
  }
  
  static func countriesFavouriteService(realm: @escaping () -> Realm) -> FavouriteCityService {
    let service = FavouriteCityService(storage: RealmStorage(realm: realm))
    return service
  }
}
extension ResourceLoader: CitiesLoader where Resource == [City] { }

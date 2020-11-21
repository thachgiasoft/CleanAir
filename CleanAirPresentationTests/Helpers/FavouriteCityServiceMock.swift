//
//  FavouriteCityServiceMock.swift
//  CleanAirPresentationTests
//
//  Created by Marko Engelman on 21/11/2020.
//

import Foundation
@testable import CleanAirModules

class FavouriteCityServiceMock: FavouriteCityService {
  var callCount = 0
  
  init() {
    super.init(storage: CityStorageMock())
  }
  
  override func toggl(for city: City, completion: (Result<City, Error>) -> Void) {
    callCount += 1
  }
}

private class CityStorageMock: CityStorage {
  init() {
    super.init(
      storeMapper: { _ in LocalCity() },
      resultMapper: { _ in
        City(
          name: "",
          country: "",
          measurementsCount: 0,
          availableLocationsCount: 0,
          isFavourite: false
        )
      })
  }
}

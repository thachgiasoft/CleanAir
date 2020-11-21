//
//  FavouriteCityServiceMock.swift
//  CleanAirPresentationTests
//
//  Created by Marko Engelman on 21/11/2020.
//

import Foundation
@testable import CleanAirModules

class FavouriteCityServiceMock: FavouriteCityService {
  typealias Result = Swift.Result<City, Error>
  typealias Completion = (Result) -> Void
  
  private var completions: [Completion] = []
  
  var callCount: Int { completions.count }
  
  init() {
    super.init(storage: CityStorageMock())
  }
  
  override func toggl(for city: City, completion: @escaping Completion) {
    completions.append(completion)
  }
  
  func complete(at: Int, with result: Result) {
    let completion = completions[at - 1]
    completion(result)
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

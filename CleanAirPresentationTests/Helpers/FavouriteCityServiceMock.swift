//
//  FavouriteCityServiceMock.swift
//  CleanAirPresentationTests
//
//  Created by Marko Engelman on 21/11/2020.
//

import Foundation
@testable import CleanAirModules
@testable import RealmSwift

class FavouriteCityServiceMock: FavouriteCityService {
  private var completions: [String: City] = [:]
  private var error: Error?
  var callCount: Int { completions.count }
  
  init() {
    super.init(storage: CityStorageMock())
  }
  
  override func toggl(for city: City) throws -> City {
    if let error = error {
      throw error
    } else {
      return completions[city.id]!
    }
  }
  
  func complete(at: Int, with city: City) {
    completions[city.id] = city
  }
  
  func complete(at: Int, with error: Error) {
    self.error = error
  }
}

class CityStorageMock: CityStorage {
  var loadCalls = 0
  var city: City?
  var observer: CityStorageLoadRequestObserverMock?
  
  class CityStorageLoadRequestObserverMock: CityStorageLoadRequestObserver {
    var city: City? {
      didSet {
        if let city = city {
          inserted?(([], [city]))
        } else {
          removed?(([], []))
        }
      }
    }
    
    var inserted: (((insertionIndexes: [Int], updatedLoadResult: [City])) -> Void)?
    var removed: (((removalIndexes: [Int], updatedLoadResult: [City])) -> Void)?
  }
  
  func store(_ city: City) throws {
    self.city = city
    observer?.city = city
  }
  
  func load(cityId: String) -> City? {
    return nil
  }
  
  func load(with request: CityStorageLoadRequest) -> (result: [City], requestObserver: CityStorageLoadRequestObserver) {
    loadCalls += 1
    let cities: [City] = city != nil ? [city!] : []
    observer = CityStorageLoadRequestObserverMock()
    observer?.city = city
    return (cities, observer!)
  }
  
  func remove(cityId: String) throws {
    city = nil
    observer?.city = nil
  }
}

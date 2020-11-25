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

private class CityStorageMock: CityStorage {
  func store(_ city: City)  throws {
    
  }
  
  func load() -> [City]? {
    return nil
  }
  
  func load(cityId: String) -> City? {
    return nil
  }
  
  func remove(cityId: String) throws {
    
  }
}

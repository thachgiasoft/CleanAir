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
  func store(_ object: City)  throws {
    
  }
  
  func load() -> [City]? {
    return nil
  }
  
  func load(objectId: Any) -> City? {
    return nil
  }
  
  func remove(objectId: Any) throws {
    
  }
}

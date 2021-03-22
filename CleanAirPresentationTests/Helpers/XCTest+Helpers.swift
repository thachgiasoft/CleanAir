//
//  XCTest+Helpers.swift
//  CleanAirPresentationTests
//
//  Created by Marko Engelman on 21/11/2020.
//

import XCTest
@testable import CleanAirModules

extension XCTestCase {
  var anyResource: String { "anyResource" }
  var anyError: NSError { NSError(domain: "anyError", code: 1, userInfo: [:]) }
  
  func anyCity() -> City {
    City(
      name: "anyCity",
      country: "anyContry",
      measurementsCount: 0,
      availableLocationsCount: 0,
      isFavourite: false
    )
  }
}

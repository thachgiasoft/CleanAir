//
//  APITests.swift
//  CleanAirModulesTests
//
//  Created by Marko Engelman on 21/11/2020.
//

import XCTest
@testable import CleanAirModules

class APITests: XCTestCase {
  func test_doesnt_crash() {
    _ = APIURL.countries
    _ = APIURL.cities(for: "anyCityName")
    _ = APIURL.cities()
  }
}

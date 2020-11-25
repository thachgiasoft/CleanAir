//
//  CountriesCachePolicyTests.swift
//  CleanAirModulesTests
//
//  Created by Marko Engelman on 25/11/2020.
//

import XCTest
@testable import CleanAirModules

class CountriesCachePolicyTests: XCTestCase {
  func test_policy_confirmsValidCache() {
    let timeStamp = Date()
    XCTAssertTrue(CountriesCachePolicy.validate(cacheTimeStamp: timeStamp))
  }
  
  func test_policy_deniesInValidCache() {
    let timeStamp = Date().addingTimeInterval(-CountriesCachePolicy.validCacheDuration)
    XCTAssertFalse(CountriesCachePolicy.validate(cacheTimeStamp: timeStamp))
  }
}

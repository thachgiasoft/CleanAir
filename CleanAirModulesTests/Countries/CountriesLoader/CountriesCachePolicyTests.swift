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
    XCTAssertTrue(CountriesCachePolicy.validate(cacheTimeStamp: timeStamp, against: timeStamp))
  }
  
  func test_policy_deniesInValidCache() {
    let now = Date()
    let timeStamp = now.addingTimeInterval(-CountriesCachePolicy.validCacheDuration-1)
    XCTAssertFalse(CountriesCachePolicy.validate(cacheTimeStamp: timeStamp, against: now))
  }
}

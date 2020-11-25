//
//  CleanAirEndToEndTests.swift
//  CleanAirEndToEndTests
//
//  Created by Marko Engelman on 24/11/2020.
//

import XCTest
@testable import CleanAirModules

class CleanAirEndToEndTests: XCTestCase {
  func test_countries_endpoint_delivers_countries() throws {
    let loader = ResourceLoader(
      client: makeClient(),
      url: APIURL.countries,
      mapper: ResourceResultsMapper(CountryMapper.map).map
    )
    
    let exp = expectation(description: "Waiting for countries")
    var result: Swift.Result<[Country], Error>?
    loader.load { loadedResult in
      result = loadedResult
      exp.fulfill()
    }
    
    wait(for: [exp], timeout: 10)
    XCTAssertNoThrow(try result?.get(), "Expected countries, got error instead")
  }
  
  func test_city_endpoint_delivers_cities() throws {
    let loader = ResourceLoader(
      client: makeClient(),
      url: APIURL.cities(),
      mapper: ResourceResultsMapper(CityMapper.map).map
    )
    
    let exp = expectation(description: "Waiting for cities")
    var result: Swift.Result<[City], Error>?
    loader.load { loadedResult in
      result = loadedResult
      exp.fulfill()
    }
    
    wait(for: [exp], timeout: 10)
    XCTAssertNoThrow(try result?.get(), "Expected cities, got error instead")
  }
}

// MARK: - Private
private extension CleanAirEndToEndTests {
  func makeClient(timeout: TimeInterval = 10) -> HTTPClient {
    let configuration: URLSessionConfiguration = .ephemeral
    configuration.timeoutIntervalForRequest = timeout
    let session = URLSession(configuration: configuration)
    let client = URLSessionHTTPClient(session: session)
    return client
  }
}

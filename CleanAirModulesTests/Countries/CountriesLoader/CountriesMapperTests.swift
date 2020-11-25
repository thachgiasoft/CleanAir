//
//  CountriesMapperTests.swift
//  CleanAirModulesTests
//
//  Created by Marko Engelman on 25/11/2020.
//

import XCTest
@testable import CleanAirModules

class CountriesMapperTests: XCTestCase {
  func test_map_mapsRemoteCountry_toCountry() {
    let remoteCoutries = [anyRemoteCountry()]
    let countries = CountryMapper.map(remoteCoutries)
    countries.enumerated().forEach { index, country in
      let remoteCountry = remoteCoutries[index]
      expect(country: country, equalTo: remoteCountry)
    }
  }
}

// MARK: - Private
private extension CountriesMapperTests {
  func expect(country: Country, equalTo remoteCountry: RemoteCountry) {
    XCTAssertEqual(country.name, remoteCountry.name)
    XCTAssertEqual(country.code, remoteCountry.code)
    XCTAssertEqual(country.numberOfMeasuredCities, remoteCountry.cities)
    XCTAssertEqual(country.numberOfMeasuringLocations, remoteCountry.locations)
    XCTAssertEqual(country.totalNumberOfMeasurements, remoteCountry.count)
  }
  
  func anyRemoteCountry() -> RemoteCountry {
    let code = UUID().uuidString
    let name = UUID().uuidString
    let country = RemoteCountry(
      code: code,
      name: name,
      count: Int.random(in: 0...9999),
      cities: Int.random(in: 0...9999),
      locations: Int.random(in: 0...9999)
    )
    return country
  }
}

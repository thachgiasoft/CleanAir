//
//  CityMapperTests.swift
//  CleanAirModulesTests
//
//  Created by Marko Engelman on 23/11/2020.
//

import XCTest
@testable import CleanAirModules

class CityMapperTests: XCTestCase {
  func test_map_mapsRemoteCity_toCity() {
    let remoteCities = [anyRemoveCity()]
    let cities = CityMapper.map(remoteCities)
    cities.enumerated().forEach { index, city in
      let remoteCity = remoteCities[index]
      expect(city: city, equalTo: remoteCity)
    }
  }
  
  func test_map_skipsInvalidCity() {
    let invalidCities = CityMapper.invalidNames.map { anyRemoveCity(name: $0) }
    XCTAssertTrue(CityMapper.map(invalidCities).isEmpty)
  }
}

// MARK: - Private
private extension CityMapperTests {
  func expect(city: City, equalTo remoteCity: RemoteCity) {
    XCTAssertEqual(city.id, remoteCity.city)
    XCTAssertEqual(city.name, remoteCity.city)
    XCTAssertEqual(city.country, remoteCity.country)
    XCTAssertEqual(city.availableLocationsCount, remoteCity.locations)
    XCTAssertEqual(city.measurementsCount, remoteCity.count)
    XCTAssertEqual(city.isFavourite, false)
  }
  
  func anyRemoveCity(name: String = UUID().uuidString) -> RemoteCity {
    let country = UUID().uuidString
    let city = RemoteCity(
      city: name,
      country: country,
      count: Int.random(in: 0...9999),
      locations: Int.random(in: 0...9999)
    )
    return city
  }
}

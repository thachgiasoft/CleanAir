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
}

// MARK: - Private
private extension CityMapperTests {
  func expect(city: City, equalTo remoteCity: RemoteCity) {
    XCTAssertEqual(city.id, remoteCity.name)
    XCTAssertEqual(city.name, remoteCity.name)
    XCTAssertEqual(city.country, remoteCity.country)
    XCTAssertEqual(city.availableLocationsCount, remoteCity.locations)
    XCTAssertEqual(city.measurementsCount, remoteCity.count)
    XCTAssertEqual(city.isFavourite, false)
  }
  
  func anyRemoveCity() -> RemoteCity {
    let name = UUID().uuidString
    let country = UUID().uuidString
    let city = RemoteCity(
      name: name,
      country: country,
      count: Int.random(in: 0...9999),
      locations: Int.random(in: 0...9999)
    )
    return city
  }
}

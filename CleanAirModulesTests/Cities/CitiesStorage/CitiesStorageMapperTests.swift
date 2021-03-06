//
//  CitiesStorageMapperTests.swift
//  CleanAirModulesTests
//
//  Created by Marko Engelman on 23/11/2020.
//

import XCTest
@testable import CleanAirModules

class CitiesStorageMapperTests: XCTestCase {
  func test_mapper_mapsCity_toLocalCity() {
    let city = anyCity()
    let localCity = CitiesStorageMapper.map(city)
    expect(city: city, equalTo: localCity)
  }
  
  func test_mapper_mapsCities_toLocalCities() {
    let city1 = anyCity()
    let city2 = anyCity()
    let cities = [city1, city2]
    let localCities = CitiesStorageMapper.map(cities)
    
    localCities.enumerated().forEach { index, localCity in expect(city: cities[index], equalTo: localCity) }
  }
  
  func test_mapper_mapsLocal_toCity() {
    let localCity = anyLocalCity()
    let city = CitiesStorageMapper.map(localCity)
    expect(city: city, equalTo: localCity)
  }
}

// MARK: - Private
private extension CitiesStorageMapperTests {
  func expect(city: City, equalTo localCity: RealmCity) {
    XCTAssertEqual(city.id, localCity.name)
    XCTAssertEqual(city.name, localCity.name)
    XCTAssertEqual(city.country, localCity.country)
    XCTAssertEqual(city.availableLocationsCount, localCity.availableLocationsCount)
    XCTAssertEqual(city.measurementsCount, localCity.measurementsCount)
    XCTAssertEqual(city.isFavourite, localCity.isFavourite)
  }
}

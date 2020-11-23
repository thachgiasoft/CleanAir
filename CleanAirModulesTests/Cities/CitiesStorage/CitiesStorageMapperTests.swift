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
  func expect(city: City, equalTo localCity: LocalCity) {
    XCTAssertEqual(city.id, localCity.name)
    XCTAssertEqual(city.name, localCity.name)
    XCTAssertEqual(city.country, localCity.country)
    XCTAssertEqual(city.availableLocationsCount, localCity.availableLocationsCount)
    XCTAssertEqual(city.measurementsCount, localCity.measurementsCount)
    XCTAssertEqual(city.isFavourite, localCity.isFavourite)
  }
  
  func anyCity() -> City {
    let name = UUID().uuidString
    let country = UUID().uuidString
    return City(
      name: name,
      country: country,
      measurementsCount: 1,
      availableLocationsCount: 1,
      isFavourite: false
    )
  }
  
  func anyLocalCity() -> LocalCity {
    let name = UUID().uuidString
    let country = UUID().uuidString
    let city = LocalCity()
    city.name = name
    city.country = country
    city.availableLocationsCount = 2
    city.measurementsCount = 2
    city.isFavourite = true
    return city
  }
}

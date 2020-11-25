//
//  FavouriteCityServiceTests.swift
//  CleanAirModulesTests
//
//  Created by Marko Engelman on 25/11/2020.
//

import XCTest
@testable import CleanAirModules

class FavouriteCityServiceTests: XCTestCase {
  func test_toggl_togglesOnlyFavouriteProperty() throws {
    let (sut, _) = makeSUT()
    let city = anyCity()
    let toggledCity = try sut.toggl(for: city)
    XCTAssertEqual(city.isFavourite, !toggledCity.isFavourite)
    XCTAssertEqual(city.availableLocationsCount, toggledCity.availableLocationsCount)
    XCTAssertEqual(city.country, toggledCity.country)
    XCTAssertEqual(city.id, toggledCity.id)
    XCTAssertEqual(city.measurementsCount, toggledCity.measurementsCount)
    XCTAssertEqual(city.name, toggledCity.name)
    
  }
  
  func test_toggl_storesFavouriteCity() throws {
    let (sut, storage) = makeSUT()
    let city = anyCity(isFavourite: false)
    try _ = sut.toggl(for: city)
    XCTAssertEqual(storage.stored?.isFavourite, !city.isFavourite)
  }
  
  func test_toggl_removesNonFavouriteCity() throws {
    let (sut, storage) = makeSUT()
    let city = anyCity(isFavourite: true)
    try _ = sut.toggl(for: city)
    XCTAssertNil(storage.stored)
  }
}

// MARK: - Private
private extension FavouriteCityServiceTests {
  func makeSUT() -> (FavouriteCityService, CityStorageMock) {
    let storage = CityStorageMock()
    let sut = FavouriteCityService(storage: storage)
    return (sut, storage)
  }
}

//
//  CountriesPresenterTests.swift
//  CleanAirPresentationTests
//
//  Created by Marko Engelman on 21/11/2020.
//

import XCTest
@testable import CleanAirPresentation

class CountriesPresenterTests: XCTestCase {
  func test_orders_countries() {
    let one = CountryViewModel(code: "", name: "1", totalNumberOfMeasurements: 0, numberOfMeasuredCities: 0, numberOfMeasuringLocations: 0)
    let two = CountryViewModel(code: "", name: "2", totalNumberOfMeasurements: 0, numberOfMeasuredCities: 0, numberOfMeasuringLocations: 0)
    
    let three = CountryViewModel(code: "", name: "3", totalNumberOfMeasurements: 0, numberOfMeasuredCities: 0, numberOfMeasuringLocations: 0)
    let unordered = [two, one, three]
    let ordered = [one, two, three]
    
    XCTAssertEqual(CountriesPresenter.viewModel(for: unordered), ordered)
  }
}

//
//  CitiesPresentationAdapterTests.swift
//  CleanAirPresentationTests
//
//  Created by Marko Engelman on 21/11/2020.
//

import XCTest
@testable import CleanAirPresentation
@testable import CleanAirModules

class CitiesPresentationAdapterTests: XCTestCase {
  func test_init_doesntTriggerService() {
    let (_, _, service) = makeSUT(city: anyCity())
    XCTAssertEqual(service.callCount, 0)
  }
  
  func test_toggle_triggersService() {
    let (sut, _, service) = makeSUT(city: anyCity())
    sut.togglFavourite()
    XCTAssertEqual(service.callCount, 1)
    sut.togglFavourite()
    XCTAssertEqual(service.callCount, 2)
  }
}

// MARK: - Private
private extension CitiesPresentationAdapterTests {
  typealias View = AnyResourceView<City>
  typealias Presenter = ResourcePresenter<City, View>
  typealias Adapter = CityPresentationAdapter<View>
  typealias Service = FavouriteCityServiceMock
  
  func makeSUT(city: City) -> (Adapter, Presenter, Service) {
    let view = View()
    let service = Service()
    let sut = Adapter(city: city, service: service)
    let presenter = Presenter(view: view, loadingView: view, errorView: view)
    sut.presenter = presenter
    return (sut, presenter, service)
  }
}

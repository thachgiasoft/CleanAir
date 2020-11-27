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
  
  func test_toggle_onSuccess_deliversResourceToPresenter() {
    let city = anyCity()
    let (sut, presenter, service) = makeSUT(city: city)
    service.complete(with: city)
    sut.toggleFavourite()
    XCTAssertEqual(presenter.receivedResource, city)
  }
  
  func test_toggle_onFailure_deliversErrorToPresenter() {
    let (sut, presenter, service) = makeSUT(city: anyCity())
    let error = NSError(domain: "1", code: 1, userInfo: [:])
    service.complete(with: error)
    sut.toggleFavourite()
    XCTAssertEqual(presenter.receivedError as NSError?, error)
  }
}

// MARK: - Private
private extension CitiesPresentationAdapterTests {
  typealias View = AnyResourceView<City>
  typealias Presenter = AnyResourcePresenterMock<City, View>
  typealias Adapter = CityPresentationAdapter<View>
  typealias Service = FavouriteCityServiceMock
  
  func makeSUT(city: City) -> (Adapter, Presenter, Service) {
    let view = View()
    let service = Service()
    let sut = Adapter(city: city, service: service)
    let presenter = Presenter(view: view, errorView: view)
    sut.presenter = presenter
    return (sut, presenter, service)
  }
  
  class AnyResourcePresenterMock<Resource, View>: ResourcePresenter<Resource, View> where View: AnyResourceView<Resource> {
    var didStartLoadingCount = 0
    var receivedResource: Resource?
    var receivedError: Error?
    
    override public func didReceiveRequesToShow(resource: Resource) {
      receivedResource = resource
    }
    
    override public func didReceiveRequesToShowResource(error: Error) {
      receivedError = error
    }
  }
}

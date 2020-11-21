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
    sut.toggleFavourite()
    XCTAssertEqual(service.callCount, 1)
    sut.toggleFavourite()
    XCTAssertEqual(service.callCount, 2)
  }
  
  func test_toggle_triggersPresenter() {
    let (sut, presenter, _) = makeSUT(city: anyCity())
    sut.toggleFavourite()
    XCTAssertEqual(presenter.didStartLoadingCount, 1)
  }
  
  func test_toggle_onSuccess_deliversResourceToPresenter() {
    let city = anyCity()
    let (sut, presenter, service) = makeSUT(city: city)
    
    expect(sut: sut, presenter: presenter, toComplete: .success(city), when: {
      service.complete(at: 1, with: .success(city))
    })
  }
  
  func test_toggle_onFailure_deliversErrorToPresenter() {
    let (sut, presenter, service) = makeSUT(city: anyCity())
    let error = NSError(domain: "1", code: 1, userInfo: [:])
    expect(sut: sut, presenter: presenter, toComplete: .failure(error), when: {
      service.complete(at: 1, with: .failure(error))
    })
  }
}

// MARK: - Private
private extension CitiesPresentationAdapterTests {
  typealias View = AnyResourceView<City>
  typealias Presenter = AnyResourcePresenterStub<City, View>
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
  
  func expect(sut: Adapter, presenter: Presenter, toComplete result: Swift.Result<City, Error>, when: () -> Void) {
    let exp = expectation(description: "Waiting for deliver completion")
    
    sut.toggleFavourite()
    when()
    
    DispatchQueue.main.async {
      switch result {
      case let .success(resource):
        XCTAssertEqual(presenter.receivedResource, resource)
        
      case let .failure(error):
        XCTAssertEqual(presenter.receivedError as NSError?, error as NSError?)
      }
      
      exp.fulfill()
    }
    
    wait(for: [exp], timeout: 2.0)
  }
}

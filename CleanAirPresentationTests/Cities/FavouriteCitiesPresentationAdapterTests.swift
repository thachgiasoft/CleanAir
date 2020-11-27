//
//  FavouriteCitiesPresentationAdapterTests.swift
//  CleanAirPresentationTests
//
//  Created by Marko Engelman on 27/11/2020.
//

import XCTest
@testable import CleanAirPresentation
@testable import CleanAirModules

class FavouriteCitiesPresentationAdapterTests: XCTestCase {
  func test_init_doesntTriggerStorage() {
    let (_, _, storage) = makeSUT()
    XCTAssertEqual(storage.loadCalls, .zero)
  }

  func test_load_deliversResourceToPresenter() throws {
    let city = anyCity()
    let (sut, presenter, storage) = makeSUT()
    try? storage.store(city)
    sut.load()
    XCTAssertEqual(presenter.receivedResource, [city])
  }

  func test_tokenChange_deliversUpdatedResource_onInsertion_toPresenter() throws {
    let (sut, presenter, storage) = makeSUT()
    try? storage.store(anyCity())
    sut.load()
    
    let newCity = anyCity()
    try storage.store(newCity)
    XCTAssertEqual(presenter.receivedResource, [newCity])
  }
  
  func test_tokenChange_deliversUpdatedResource_onRemoval_toPresenter() throws {
    let (sut, presenter, storage) = makeSUT()
    let city = anyCity()
    try? storage.store(city)
    sut.load()
    
    try storage.remove(cityId: city.id)
    XCTAssertEqual(presenter.receivedResource, [])
  }
}

// MARK: - Private
private extension FavouriteCitiesPresentationAdapterTests {
  typealias Presenter = AnyResourcePresenterStub<[City], AnyResourceView<[City]>>
  typealias Adapter = FavouriteCitiesPresentationAdapter<AnyResourceView<[City]>>
  typealias Storage = CityStorageMock
  
  func makeSUT() -> (Adapter, Presenter, CityStorageMock) {
    let view = AnyResourceView<[City]>()
    let storage = Storage()
    let sut = Adapter(storage: storage)
    let presenter = Presenter(view: view, errorView: view)
    sut.presenter = presenter
    return (sut, presenter, storage)
  }
}

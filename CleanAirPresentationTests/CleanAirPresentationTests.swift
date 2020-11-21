//
//  CleanAirPresentationTests.swift
//  CleanAirPresentationTests
//
//  Created by Marko Engelman on 21/11/2020.
//

import XCTest
@testable import CleanAirPresentation

class CleanAirPresentationTests: XCTestCase {
  func test_init_doesntTriggerLoader() {
    let (_, _, loader) = makeSUT()
    XCTAssertEqual(loader.loadCount, 0)
  }
  
  func test_load_triggersLoader() {
    let (sut, _, loader) = makeSUT()
    sut.load()
    XCTAssertEqual(loader.loadCount, 1)
    sut.load()
    XCTAssertEqual(loader.loadCount, 2)
  }
  
  func test_load_callsPresenter_didStartLoading() {
    let (sut, presenter, _) = makeSUT()
    sut.load()
    XCTAssertEqual(presenter.didStartLoadingCount, 1)
    sut.load()
    XCTAssertEqual(presenter.didStartLoadingCount, 2)
  }
}

// MARK: - Private
private extension CleanAirPresentationTests {
  typealias AnyType = String
  typealias AnyView = AnyResourceView<AnyType>
  typealias AnyLoader = AnyResourceLoader<AnyType>
  typealias AnyPresenter = AnyResourcePresenterStub<AnyType, AnyView>
  typealias AnyPresentationAdapter = ResourcePresentationAdapter<AnyType, AnyView>
  
  func makeSUT() -> (AnyPresentationAdapter, AnyPresenter, AnyLoader) {
    let view = AnyView()
    let loader = AnyLoader()
    let sut = AnyPresentationAdapter(loader: loader.load)
    let presenter = AnyPresenter(view: view, loadingView: view, errorView: view)
    sut.presenter = presenter
    return (sut, presenter, loader)
  }
}

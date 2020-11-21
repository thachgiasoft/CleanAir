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
    let (_, loader) = makeSUT()
    XCTAssertEqual(loader.loadCount, 0)
  }
  
  func test_load_triggersLoader() {
    let (sut, loader) = makeSUT()
    sut.load()
    XCTAssertEqual(loader.loadCount, 1)
    sut.load()
    XCTAssertEqual(loader.loadCount, 2)
  }
}

// MARK: - Private
private extension CleanAirPresentationTests {
  typealias AnyType = String
  typealias AnyView = AnyResourceView<AnyType>
  typealias AnyLoader = AnyResourceLoader<AnyType>
  typealias AnyPresenter = ResourcePresenter<AnyType, AnyView>
  typealias AnyPresentationAdapter = ResourcePresentationAdapter<AnyType, AnyView>
  
  func makeSUT() -> (AnyPresentationAdapter, AnyLoader) {
    let view = AnyView()
    let loader = AnyLoader()
    let sut = AnyPresentationAdapter(loader: loader.load)
    sut.presenter = AnyPresenter(view: view, loadingView: view, errorView: view)
    return (sut, loader)
  }
}

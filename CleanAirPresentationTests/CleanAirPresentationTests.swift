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
  
  func test_load_onSuccess_deliversResourceToPresenter() {
    let queue = DispatchQueue.main
    let (sut, presenter, loader) = makeSUT(queue: queue)
    sut.load()
    let one = 1
    let oneString = "\(one)"
    let exp = expectation(description: "Waiting for deliver completion")
    loader.complete(at: one, with: .success(oneString))
    queue.async { exp.fulfill() }
    wait(for: [exp], timeout: 1.0)
    XCTAssertEqual(presenter.receivedResource, oneString)
  }
}

// MARK: - Private
private extension CleanAirPresentationTests {
  typealias AnyType = String
  typealias AnyView = AnyResourceView<AnyType>
  typealias AnyLoader = AnyResourceLoader<AnyType>
  typealias AnyPresenter = AnyResourcePresenterStub<AnyType, AnyView>
  typealias AnyPresentationAdapter = ResourcePresentationAdapter<AnyType, AnyView>
  
  func makeSUT(queue: DispatchQueue = .main) -> (AnyPresentationAdapter, AnyPresenter, AnyLoader) {
    let view = AnyView()
    let loader = AnyLoader()
    let sut = AnyPresentationAdapter(loader: loader.load)
    let presenter = AnyPresenter(view: view, loadingView: view, errorView: view)
    sut.presenter = presenter
    return (sut, presenter, loader)
  }
}

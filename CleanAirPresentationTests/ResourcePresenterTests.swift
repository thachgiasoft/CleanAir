//
//  ResourcePresenterTests.swift
//  CleanAirPresentationTests
//
//  Created by Marko Engelman on 21/11/2020.
//

import XCTest
@testable import CleanAirPresentation

class ResourcePresenterTests: XCTestCase {
  func test_init_doesnt_callView() {
    let (_, view) = makeSUT()
    XCTAssertNil(view.receivedResourceViewModel)
    XCTAssertNil(view.receivedResourceLoadingViewModel)
    XCTAssertNil(view.receivedResourceErrorViewModel)
  }
  
  func test_didStartLoading_triggersLoading() {
    let (sut, view) = makeSUT()
    sut.didStartLoading()
    XCTAssertTrue(view.receivedResourceLoadingViewModel!.isLoading)
  }
  
  func test_didFinishLoadingWithResource_stopsLoading() {
    let (sut, view) = makeSUT()
    sut.didFinishLoading(with: anyResource)
    XCTAssertFalse(view.receivedResourceLoadingViewModel!.isLoading)
  }
  
  func test_didFinishLoadingWithResource_deliversResource() {
    let (sut, view) = makeSUT()
    sut.didFinishLoading(with: anyResource)
    XCTAssertEqual(view.receivedResourceViewModel, anyResource)
  }
  
  func test_didFinishLoadingWithResource_deliversResourceViewModel() {
    var didMap = false
    let mapper: (String) -> String = { resource in didMap = true; return resource }
    let (sut, _) = makeSUT(mapper: mapper)
    sut.didFinishLoading(with: anyResource)
    XCTAssertTrue(didMap)
  }
  
  func test_didFinishLoadingWithError_stopsLoading() {
    let (sut, view) = makeSUT()
    sut.didFinishLoading(with: anyError)
    XCTAssertFalse(view.receivedResourceLoadingViewModel!.isLoading)
  }
  
  func test_didFinishLoadingWithError_deliversError() {
    let (sut, view) = makeSUT()
    sut.didFinishLoading(with: anyError)
    XCTAssertNotNil(view.receivedResourceErrorViewModel)
  }
}

// MARK: - Private
private extension ResourcePresenterTests {
  typealias AnyType = String
  typealias AnyView = AnyResourceView<AnyType>
  typealias Presenter = ResourcePresenter<AnyType, AnyView>
  
  func makeSUT(mapper: @escaping (AnyType) -> (AnyType) = { $0 }) -> (Presenter, AnyView) {
    let view = AnyView()
    let presenter = Presenter(view: view, loadingView: view, errorView: view, viewModelMapper: mapper)
    return (presenter, view)
  }
}

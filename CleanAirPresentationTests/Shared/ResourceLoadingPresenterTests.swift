//
//  ResourcePresenterTests.swift
//  CleanAirPresentationTests
//
//  Created by Marko Engelman on 21/11/2020.
//

import XCTest
@testable import CleanAirPresentation

class ResourceLoadingPresenterTests: XCTestCase {
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
    let mappedResource = anyResource
    let resource = anyResource
    let view = AnyView()
    let sut = Presenter(view: view, loadingView: view, errorView: view)
    sut.didFinishLoading(with: resource)
    XCTAssertEqual(view.receivedResourceViewModel, mappedResource)
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
private extension ResourceLoadingPresenterTests {
  typealias AnyType = String
  typealias AnyView = AnyResourceView<AnyType>
  typealias Presenter = ResourceLoadingPresenter<AnyType, AnyView>
  
  func makeSUT(mapper: @escaping (AnyType) -> (AnyType) = { $0 }) -> (Presenter, AnyView) {
    let view = AnyView()
    let presenter = Presenter(view: view, loadingView: view, errorView: view, viewModelMapper: mapper)
    return (presenter, view)
  }
}

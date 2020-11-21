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
    sut.didFinishLoading(with: "")
    XCTAssertFalse(view.receivedResourceLoadingViewModel!.isLoading)
  }
  
  func test_didFinishLoadingWithResource_deliversResource() {
    let (sut, view) = makeSUT()
    let anyString = "anyString"
    sut.didFinishLoading(with: anyString)
    XCTAssertEqual(view.receivedResourceViewModel, anyString)
  }
  
  func test_didFinishLoadingWithError_stopsLoading() {
    let (sut, view) = makeSUT()
    sut.didFinishLoading(with: NSError(domain: "anyError", code: 1, userInfo: [:]))
    XCTAssertFalse(view.receivedResourceLoadingViewModel!.isLoading)
  }
}

// MARK: - Private
private extension ResourcePresenterTests {
  typealias AnyType = String
  typealias AnyView = AnyResourceView<AnyType>
  typealias Presenter = ResourcePresenter<AnyType, AnyView>
  
  func makeSUT() -> (Presenter, AnyView) {
    let view = AnyView()
    let presenter = Presenter(view: view, loadingView: view, errorView: view)
    return (presenter, view)
  }
}

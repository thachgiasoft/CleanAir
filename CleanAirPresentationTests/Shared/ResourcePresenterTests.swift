//
//  ResourcePresenterTests.swift
//  CleanAirPresentationTests
//
//  Created by Marko Engelman on 27/11/2020.
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
  
  func test_didReceiveRequesToShow_deliversResource() {
    let (sut, view) = makeSUT()
    sut.didReceiveRequesToShow(resource: anyResource)
    XCTAssertEqual(view.receivedResourceViewModel, anyResource)
  }
  
  func test_didFinishLoadingWithResource_deliversResourceViewModel() {
    let mappedResource = anyResource
    let resource = anyResource
    let view = AnyView()
    let sut = Presenter(view: view, errorView: view)
    sut.didReceiveRequesToShow(resource: resource)
    XCTAssertEqual(view.receivedResourceViewModel, mappedResource)
  }
  
  func test_didReceiveRequesToShowResource_deliversError() {
    let (sut, view) = makeSUT()
    sut.didReceiveRequesToShowResource(error: anyError)
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
    let presenter = Presenter(view: view, errorView: view, viewModelMapper: mapper)
    return (presenter, view)
  }
}

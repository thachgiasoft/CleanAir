//
//  ResourcePresenterTests.swift
//  CleanAirPresentationTests
//
//  Created by Marko Engelman on 21/11/2020.
//

import XCTest

class ResourcePresenterTests: XCTestCase {
  func test_init_doesnt_callView() {
    let (_, view) = makeSUT()
    XCTAssertNil(view.receivedResourceViewModel)
    XCTAssertNil(view.receivedResourceLoadingViewModel)
    XCTAssertNil(view.receivedResourceErrorViewModel)
  }
}

// MARK: - Private
private extension ResourcePresenterTests {
  typealias AnyType = String
  typealias AnyView = AnyResourceView<AnyType>
  typealias AnyPresenter = AnyResourcePresenterStub<AnyType, AnyView>
  
  func makeSUT() -> (AnyPresenter, AnyView) {
    let view = AnyView()
    let presenter = AnyPresenter(view: view, loadingView: view, errorView: view)
    return (presenter, view)
  }
}

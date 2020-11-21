//
//  ResourcePresenterTests.swift
//  CleanAirPresentationTests
//
//  Created by Marko Engelman on 21/11/2020.
//

import XCTest

class ResourcePresenterTests: XCTestCase {
  
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

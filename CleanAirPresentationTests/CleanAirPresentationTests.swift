//
//  CleanAirPresentationTests.swift
//  CleanAirPresentationTests
//
//  Created by Marko Engelman on 21/11/2020.
//

import XCTest
@testable import CleanAirPresentation

class CleanAirPresentationTests: XCTestCase {
}

// MARK: - Private
private extension CleanAirPresentationTests {
  typealias AnyType = String
  typealias AnyView = AnyResourceView<AnyType>
  typealias AnyLoader = AnyResourceLoader<AnyType>
  typealias AnyPresenter = ResourcePresenter<AnyType, AnyView>
  typealias AnyPresentationAdapter = ResourcePresentationAdapter<AnyType, AnyView>
  
  func makeSUT() -> AnyPresentationAdapter {
    let view = AnyView()
    let sut = AnyPresentationAdapter(loader: AnyLoader().load)
    sut.presenter = AnyPresenter(view: view, loadingView: view, errorView: view)
    return sut
  }
}

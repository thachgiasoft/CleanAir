//
//  ResourceLoadingPresentationAdapterTests.swift
//  CleanAirPresentationTests
//
//  Created by Marko Engelman on 21/11/2020.
//

import XCTest
@testable import CleanAirPresentation

class ResourceLoadingPresentationAdapterTests: XCTestCase {
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
    let (sut, presenter, loader) = makeSUT()
    let one = 1
    let oneString = "\(one)"
    
    expect(sut: sut, presenter: presenter, toComplete: .success(oneString), when: {
      loader.complete(at: one, with: .success(oneString))
    })
  }
  
  func test_load_onFailure_deliversErrorToPresenter() {
    let (sut, presenter, loader) = makeSUT()
    let error = NSError(domain: "1", code: 1, userInfo: [:])
    expect(sut: sut, presenter: presenter, toComplete: .failure(error), when: {
      loader.complete(at: 1, with: .failure(error))
    })
  }
}

// MARK: - Private
private extension ResourceLoadingPresentationAdapterTests {
  typealias AnyType = String
  typealias AnyView = AnyResourceView<AnyType>
  typealias AnyLoader = AnyResourceLoader<AnyType>
  typealias AnyPresenter = AnyResourceLoadingPresenterStub<AnyType, AnyView>
  typealias AnyPresentationAdapter = ResourceLoadingPresentationAdapter<AnyType, AnyView>
  
  func makeSUT(queue: DispatchQueue = .main) -> (AnyPresentationAdapter, AnyPresenter, AnyLoader) {
    let view = AnyView()
    let loader = AnyLoader()
    let sut = AnyPresentationAdapter(loader: loader.load)
    let presenter = AnyPresenter(view: view, loadingView: view, errorView: view)
    sut.presenter = presenter
    return (sut, presenter, loader)
  }
  
  func expect(sut: AnyPresentationAdapter, presenter: AnyPresenter, toComplete result: Swift.Result<AnyType, Error>, when: () -> Void) {
    let exp = expectation(description: "Waiting for deliver completion")
    
    sut.load()
    when()
    
    DispatchQueue.main.async {
      switch result {
      case let .success(resource):
        XCTAssertEqual(presenter.receivedResource, resource)
        
      case let .failure(error):
        XCTAssertEqual(presenter.receivedError as NSError?, error as NSError?)
      }
      
      exp.fulfill()
    }
    
    wait(for: [exp], timeout: 2.0)
  }
}

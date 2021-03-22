//
//  ResourceLoaderTests.swift
//  CleanAirModulesTests
//
//  Created by Marko Engelman on 22/11/2020.
//

import XCTest
@testable import CleanAirModules

class ResourceLoaderTests: XCTestCase {
  func test_init_doesntTrigger_client() {
    let (_, client) = makeSUT()
    XCTAssertEqual(client.executeCount, .zero)
  }
  
  func test_init_doesntHaveSideEffectOnURL() {
    let url = anyURL
    let (sut, _) = makeSUT(url: url)
    XCTAssertEqual(sut.url, url)
  }
  
  func test_multipleLoadCalls_triggers_clientEqualTimes() {
    let multipleCallsCount = 5
    let (sut, client) = makeSUT()
    for _ in 0..<multipleCallsCount { sut.load { _ in } }
    XCTAssertEqual(client.executeCount, multipleCallsCount)
  }
  
  func test_load_executes_getRequest() {
    let (sut, client) = makeSUT()
    sut.load { _ in }
    let request = client.completions[0].1
    XCTAssertEqual(request.httpMethod, "GET")
  }
  
  func test_load_delivers_eventually() {
    let (sut, client) = makeSUT()
    var result: AnyResourceLoder.Result?
    let exp = expectation(description: "Waiting for deliver")
    sut.load { loadedResult in
      result = loadedResult
      exp.fulfill()
    }
    
    client.complete(at: 0)
    
    wait(for: [exp], timeout: 1.0)
    XCTAssertNotNil(result)
  }
  
  func test_load_fails_to_deliver_whenDeallocated() {
    let (sut, client) = makeSUT()
    var loader: AnyResourceLoder? = AnyResourceLoder(client: client, url: sut.url, mapper: sut.mapper)
    var result: AnyResourceLoder.Result?
    let exp = expectation(description: "Waiting for deliver")
    exp.isInverted = true
    loader?.load { loadedResult in
      result = loadedResult
      exp.fulfill()
    }
    
    loader = nil
    client.complete(at: 0)
    
    wait(for: [exp], timeout: 1.0)
    XCTAssertNil(result)
  }
  
  func test_load_cancelsTask_whenDeallocated() {
    let (sut, client) = makeSUT()
    var loader: AnyResourceLoder? = AnyResourceLoder(client: client, url: sut.url, mapper: sut.mapper)
    loader?.load { _ in }
    loader = nil
    XCTAssertTrue(client.completions[0].2.isCanceled)
  }
  
  func test_load_delivers_error_whenClientFails() {
    let (sut, client) = makeSUT()
    var result: AnyResourceLoder.Result?
    let exp = expectation(description: "Waiting for deliver")
    
    sut.load { loadedResult in
      result = loadedResult
      exp.fulfill()
    }
    
    client.complete(at: 0, with: .failure(NSError(domain: "", code: 0, userInfo: nil)))
    
    wait(for: [exp], timeout: 1.0)
    XCTAssertThrowsError(try result!.get())
  }
  
  func test_load_delivers_error_whenMapperFails() {
    let (sut, client) = makeSUT()
    var result: AnyResourceLoder.Result?
    let exp = expectation(description: "Waiting for deliver")
    
    sut.load { loadedResult in
      result = loadedResult
      exp.fulfill()
    }
    
    let invalidURLResponse = HTTPURLResponse(url: anyURL, statusCode: -1, httpVersion: nil, headerFields: [:])!
    client.complete(at: 0, with: .success((Data(), invalidURLResponse)))
    
    wait(for: [exp], timeout: 1.0)
    XCTAssertThrowsError(try result!.get())
  }
}

// MARK: - Private
private extension ResourceLoaderTests {
  typealias AnyResource = String
  typealias AnyResourceLoder = ResourceLoader<AnyResource>
  var anyURL: URL { URL(string: "https://www.anyURL.com")! }
  
  func makeSUT(url: URL =  URL(string: "https://www.anyURL.com")!) -> (AnyResourceLoder, HTTPClientStub) {
    let client = HTTPClientStub()
    let loader = AnyResourceLoder(
      client: client,
      url: url,
      mapper: ResourceResultsMapper({ $0 }).map
    )
    return (loader, client)
  }
  
  class HTTPClientStub: HTTPClient {
    var completions: [(((HTTPClient.Result) -> Void), URLRequest, HTTPClientTaskMock)] = []
    var executeCount: Int { completions.count }
    
    class HTTPClientTaskMock: HTTPClientTask {
      let request: URLRequest
      var isCanceled = false
     
      init(_ request: URLRequest) {
        self.request = request
      }
      
      func cancel() {
        isCanceled = true
      }
    }
    
    func execute(request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
      let task = HTTPClientTaskMock(request)
      completions.append((completion, request, task))
      return task
    }
    
    func complete(at: Int, with result: HTTPClient.Result = .failure(NSError(domain: "", code: 0, userInfo: nil))) {
      completions[at].0(result)
    }
  }
}



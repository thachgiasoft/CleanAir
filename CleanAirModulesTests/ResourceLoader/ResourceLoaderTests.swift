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
    var completions: [(((HTTPClient.Result) -> Void), URLRequest)] = []
    var executeCount: Int { completions.count }
    
    class HTTPClientTaskMock: HTTPClientTask {
      let request: URLRequest
      
      init(_ request: URLRequest) {
        self.request = request
      }
      
      func cancel() { }
    }
    
    func execute(request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
      completions.append((completion, request))
      return HTTPClientTaskMock(request)
    }
    
    func complete(at: Int) {
      completions[at].0(.failure(NSError(domain: "", code: 0, userInfo: nil)))
    }
  }
}



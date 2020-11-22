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
  
  func test_getRequest_configures_httpMethod_to_GET() {
    let (sut, _) = makeSUT()
    let request = sut.getRequest()
    XCTAssertEqual(request.httpMethod, "GET")
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
    private var completions: [(HTTPClient.Result) -> Void] = []
    var executeCount: Int { completions.count }
    
    class HTTPClientTaskMock: HTTPClientTask {
      func cancel() { }
    }
    
    func execute(request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
      completions.append(completion)
      return HTTPClientTaskMock()
    }
  }
}



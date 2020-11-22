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
}

// MARK: - Private
private extension ResourceLoaderTests {
  typealias AnyResource = String
  typealias AnyResourceLoder = ResourceLoader<AnyResource>
  
  func makeSUT() -> (AnyResourceLoder, HTTPClientStub) {
    let url = URL(string: "https://www.anyURL.com")!
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



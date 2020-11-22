//
//  ResourceLoaderTests.swift
//  CleanAirModulesTests
//
//  Created by Marko Engelman on 22/11/2020.
//

import XCTest
@testable import CleanAirModules

class ResourceLoaderTests: XCTestCase {

}

// MARK: - Private
private extension ResourceLoaderTests {
  typealias AnyResource = String
  typealias AnyResourceLoder = ResourceLoader<AnyResource>
  
  func makeSUT() -> AnyResourceLoder {
    let url = URL(string: "https://www.anyURL.com")!
    let client = HTTPClientStub()
    let loader = AnyResourceLoder(
      client: client,
      url: url,
      mapper: ResourceResultsMapper({ $0 }).map
    )
    return loader
  }
  
  class HTTPClientStub: HTTPClient {
    class HTTPClientTaskMock: HTTPClientTask {
      func cancel() { }
    }
    
    func execute(request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
      return HTTPClientTaskMock()
    }
  }
}



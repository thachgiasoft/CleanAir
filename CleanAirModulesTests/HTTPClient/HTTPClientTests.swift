//
//  HTTPClientTests.swift
//  CleanAirModulesTests
//
//  Created by Marko Engelman on 21/11/2020.
//

import XCTest
@testable import CleanAirModules

class HTTPClientTests: XCTestCase {
  func test_init_storesSession() {
    let configuration = URLSessionConfiguration.ephemeral
    let session = URLSession(configuration: configuration)
    let sut = makeSUT(session: session)
    XCTAssertEqual(sut.session, session)
  }
}

// MARK: - Private
private extension HTTPClientTests {
  func makeSUT(session: URLSession = .shared) -> URLSessionHTTPClient {
    return URLSessionHTTPClient(session: session)
  }
}

//
//  ResourceLoaderTests.swift
//  CleanAirModulesTests
//
//  Created by Marko Engelman on 22/11/2020.
//

import XCTest
@testable import CleanAirModules

class ResourceLoaderTests: XCTestCase {
  func test_map_throwsError_onNoOkStatusCode() {
    let sut = makeSUT()
    let anyData = Data()
    let anyURL = URL(string: "https://www.anyURL.com")!
    let noOkCode = 400
    let noOkResponse = HTTPURLResponse(url: anyURL, statusCode: noOkCode, httpVersion: nil, headerFields: nil)!
    do {
      try _ = sut.map(anyData, from: noOkResponse)
    } catch {
      XCTAssertEqual(error as NSError, Mapper.InvalidStatusCode() as NSError)
    }
  }
}

// MARK: - Private
private extension ResourceLoaderTests {
  class AnyDecodableResource: Decodable {
    let resource: AnyResource
  }
  
  typealias AnyResource = String
  typealias Mapper = ResourceMapper<AnyDecodableResource, AnyResource>
  func makeSUT() -> Mapper {
    return Mapper({ $0.resource })
  }
}

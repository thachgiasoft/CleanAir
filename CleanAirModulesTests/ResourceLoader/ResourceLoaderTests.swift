//
//  ResourceLoaderTests.swift
//  CleanAirModulesTests
//
//  Created by Marko Engelman on 22/11/2020.
//

import XCTest
@testable import CleanAirModules

class ResourceLoaderTests: XCTestCase {
  func test_map_throwsInvalidStatusError_onNoOkStatusCode() {
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
  
  func test_map_throwsInvalidDataError_onInvalidData() {
    let sut = makeSUT()
    let anyData = Data()
    let anyURL = URL(string: "https://www.anyURL.com")!
    let okCode = 200
    let okResponse = HTTPURLResponse(url: anyURL, statusCode: okCode, httpVersion: nil, headerFields: nil)!
    do {
      try _ = sut.map(anyData, from: okResponse)
    } catch {
      XCTAssertEqual(error as NSError, Mapper.InvalidData() as NSError)
    }
  }
  
  func test_map_deliversMappedResult_onValidDataAndValidResponse() throws {
    let sut = makeSUT()
    let results = ["results": AnyDecodableResource(resource: "anyString")]
    let validData = try JSONEncoder().encode(results)
    let anyURL = URL(string: "https://www.anyURL.com")!
    let okCode = 200
    let okResponse = HTTPURLResponse(url: anyURL, statusCode: okCode, httpVersion: nil, headerFields: nil)!
    XCTAssertNoThrow(try sut.map(validData, from: okResponse))
  }
}

// MARK: - Private
private extension ResourceLoaderTests {
  class AnyDecodableResource: Codable {
    let resource: AnyResource
    
    init(resource: AnyResource) {
      self.resource = resource
    }
  }
  
  typealias AnyResource = String
  typealias Mapper = ResourceMapper<AnyDecodableResource, AnyResource>
  func makeSUT() -> Mapper {
    return Mapper({ $0.resource })
  }
}

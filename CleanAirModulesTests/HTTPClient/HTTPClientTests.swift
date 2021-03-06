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
    let session = anySession
    let sut = makeSUT(session: session)
    XCTAssertEqual(sut.session, session)
  }
  
  func test_returns_cancelableTask() {
    let session = anySession
    let sut = makeSUT(session: session)
    
    let exp1 = expectation(description: "Wating for running tasks")
    let task = sut.execute(request: anyRequest) { _ in }
    var runningTasks: [URLSessionTask] = []
    session.getAllTasks { tasks in
      runningTasks.append(contentsOf: tasks)
      exp1.fulfill()
      XCTAssertFalse(runningTasks.isEmpty)
    }
    wait(for: [exp1], timeout: 1.0)
    runningTasks.removeAll()
    
    let exp2 = expectation(description: "Waiting for running tasks")
    task.cancel()
    session.getAllTasks { tasks in
      runningTasks.append(contentsOf: tasks)
      exp2.fulfill()
      XCTAssertTrue(runningTasks.isEmpty)
    }
    
    wait(for: [exp2], timeout: 1.0)
  }
  
  func test_clientResult_deliversErrorOnNonExpectedResponse() {
    let sut = makeSUT()
    let result = sut.clientResult(for: nil, response: nil, error: nil)
    XCTAssertThrowsError(try result.get())
  }
  
  func test_clientResult_deliversNoErrorOnSuccessfulResponse() {
    let sut = makeSUT()
    let response = HTTPURLResponse(url: anyURL, statusCode: 1, httpVersion: nil, headerFields: nil)
    let result = sut.clientResult(for: Data(), response: response, error: nil)
    XCTAssertNoThrow(try result.get())
  }
  
  func test_clientResultt_deliversErrorOnErrorResponse() {
    let sut = makeSUT()
    let response = HTTPURLResponse(url: anyURL, statusCode: 1, httpVersion: nil, headerFields: nil)
    let result = sut.clientResult(for: nil, response: response, error: NSError(domain: "", code: 1, userInfo: [:]))
    XCTAssertThrowsError(try result.get())
  }
  
  func test_clientResult_deliversErrorOnNonHTTPURLResponse() {
    let sut = makeSUT()
    let response = URLResponse(url: anyURL, mimeType: nil, expectedContentLength: 1, textEncodingName: nil)
    let result = sut.clientResult(for: Data(), response: response, error: nil)
    XCTAssertThrowsError(try result.get())
  }
  
  func test_clientResult_deliversResponseWithoutSideEfects() throws {
    let sut = makeSUT()
    let response = HTTPURLResponse(url: anyURL, statusCode: 1, httpVersion: nil, headerFields: nil)
    let data = Data()
    let result = sut.clientResult(for: data, response: response, error: nil)
    let (receivedData, receivedResponse) = try result.get()
    XCTAssertEqual(receivedData, data)
    XCTAssertEqual(receivedResponse, response)
  }
  
  func test_clientResult_throwsCorrectError() {
    let sut = makeSUT()
    let response = URLResponse(url: anyURL, mimeType: nil, expectedContentLength: 1, textEncodingName: nil)
    let valuesResult = sut.clientResult(for: Data(), response: response, error: nil)
    do {
      let _ = try valuesResult.get()
    } catch {
      let expectedError = error as? URLSessionHTTPClient.UnexpectedValuesRepresentation
      XCTAssertNotNil(expectedError)
    }
    
    let nsError = NSError(domain: "", code: 1, userInfo: [:])
    let validRresponse = HTTPURLResponse(url: anyURL, statusCode: 1, httpVersion: nil, headerFields: nil)
    let nsErrorResult = sut.clientResult(for: Data(), response: validRresponse, error: nsError)
    do {
      let _ = try nsErrorResult.get()
    } catch {
      XCTAssertEqual(error as NSError, nsError)
    }
    
    let inValidRresponse = URLResponse(url: anyURL, mimeType: nil, expectedContentLength: 1, textEncodingName: nil)
    let invalidResult = sut.clientResult(for: Data(), response: inValidRresponse, error: nsError)
    do {
      let _ = try invalidResult.get()
    } catch {
      XCTAssertEqual(error as NSError, nsError)
    }
  }
}

// MARK: - Private
private extension HTTPClientTests {
  var anySession: URLSession {
    URLSession(configuration: .ephemeral)
  }
  
  var anyURL: URL {
    URL(string: "https://anyURL.com")!
  }
  
  var anyRequest: URLRequest {
    URLRequest(url: anyURL)
  }
  
  func makeSUT(session: URLSession = .shared) -> URLSessionHTTPClient {
    return URLSessionHTTPClient(session: session)
  }
}

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
  
  func test_returns_cancelableTask() {
    let configuration = URLSessionConfiguration.ephemeral
    let session = URLSession(configuration: configuration)
    let sut = makeSUT(session: session)
    let anyURL = URL(string: "https://anyURL.com")!
    let anyRequest = URLRequest(url: anyURL)
    
    
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
}

// MARK: - Private
private extension HTTPClientTests {
  func makeSUT(session: URLSession = .shared) -> URLSessionHTTPClient {
    return URLSessionHTTPClient(session: session)
  }
}

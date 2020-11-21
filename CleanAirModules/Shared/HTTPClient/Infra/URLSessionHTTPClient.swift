//
//  URLSessionHTTPClient.swift
//  CleanAir
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

public class URLSessionHTTPClient {
  class WrappedTask: HTTPClientTask {
    weak var task: URLSessionTask?
    
    init(_ task: URLSessionTask) {
      self.task = task
    }
    
    func cancel() {
      task?.cancel()
    }
  }
  
  let session: URLSession
  
  private struct UnexpectedValuesRepresentation: Error {}
  
  public init(session: URLSession) {
    self.session = session
  }
}

// MARK: - HTTPClient
extension URLSessionHTTPClient: HTTPClient {
  public func execute(request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
    let result = clientResult
    let task = session.dataTask(with: request) { completion(result($0, $1, $2)) }
    task.resume()
    return WrappedTask(task)
  }
}

// MARK: - Private
private extension URLSessionHTTPClient {
  func clientResult(for data: Data?, response: URLResponse?, error: Error?) -> HTTPClient.Result {
    let result = Result {
      if let error = error {
        throw error
      } else if let data = data, let response = response as? HTTPURLResponse {
        return (data, response)
      } else {
        throw UnexpectedValuesRepresentation()
      }
    }
    return result
  }
}

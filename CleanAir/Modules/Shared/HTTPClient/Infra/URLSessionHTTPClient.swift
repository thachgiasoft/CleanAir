//
//  URLSessionHTTPClient.swift
//  CleanAir
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

class URLSessionHTTPClient {
  let session: URLSession
  
  private struct UnexpectedValuesRepresentation: Error {}
  
  init(session: URLSession) {
    self.session = session
  }
}

// MARK: - HTTPClient
extension URLSessionHTTPClient: HTTPClient {
  func execute(request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) {
    let result = clientResult
    let task = session.dataTask(with: request) { completion(result($0, $1, $2)) }
    task.resume()
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

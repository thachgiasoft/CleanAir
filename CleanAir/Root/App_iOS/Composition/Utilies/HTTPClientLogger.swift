//
//  HTTPClientLogger.swift
//  CleanAir
//
//  Created by Marko Engelman on 25/11/2020.
//

import Foundation
import CleanAirModules
import os

class HTTPClientLogger: HTTPClient {
  let client: HTTPClient
  private lazy var logger = Logger(subsystem: "com.markoengelman.CleanAir", category: "\(type(of: client))")
  
  init(client: HTTPClient) {
    self.client = client
  }
  
  func execute(request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
    var url: String = ""
    if let path = request.url?.path, let query = request.url?.query {
      url = "\(path)?\(query)"
    } else if let path = request.url?.path {
      url = "\(path)"
    }
    
    logger.debug("🚀 :: \(url)")
    let start = CFAbsoluteTimeGetCurrent()
    return client.execute(request: request) { [weak self] result in
      let end = CFAbsoluteTimeGetCurrent()
      switch result {
      case let .success((data, response)):
        self?.logger.debug("🛬 :: \(url) :: ✅ [\(response.statusCode)] :: ⏱ \(end - start)s :: 📦 \(Self.loggable(data))")
        
      case let .failure(error):
        self?.logger.debug("💣 :: \(url) :: Error: \(error.localizedDescription)")
      }
      
      completion(result)
    }
  }
}

// MARK: - Private
private extension HTTPClientLogger {
  static func loggable(_ data: Data) -> String {
    return String(data: data, encoding: .utf8) ?? ""
  }
}

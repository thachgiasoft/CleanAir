//
//  HTTPClient.swift
//  CleanAir
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

public protocol HTTPClientTask {
  func cancel()
}

public protocol HTTPClient {
  typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
  
  /// Clients are responsible to dispatch to appropriate threads, if needed.
  @discardableResult
  func execute(request: URLRequest, completion: @escaping (Result) -> Void) -> HTTPClientTask
}

//
//  HTTPClient.swift
//  CleanAir
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

protocol HTTPClient {
  typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
  
  /// Clients are responsible to dispatch to appropriate threads, if needed.
  func execute(request: URLRequest, completion: @escaping (Result) -> Void)
}

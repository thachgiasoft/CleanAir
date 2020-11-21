//
//  AnyResourceLoader.swift
//  CleanAirPresentationTests
//
//  Created by Marko Engelman on 21/11/2020.
//

import Foundation

class AnyResourceLoader<T> where T: Any {
  typealias Result = Swift.Result<T, Error>
  typealias Completion = (Result) -> Void
  
  private var completions: [Completion] = []
  var loadCount: Int { completions.count }
  
  func load(completion: @escaping Completion) {
    completions.append(completion)
  }
  
  func complete(at: Int, with result: Result) {
    let completion = completions[at - 1]
    completion(result)
  }
}

//
//  AnyResourceLoader.swift
//  CleanAirPresentationTests
//
//  Created by Marko Engelman on 21/11/2020.
//

import Foundation

class AnyResourceLoader<T> where T: Any {
  var loadCount = 0
  func load(completion: @escaping (Swift.Result<T, Error>) -> Void) {
    loadCount += 1
  }
}

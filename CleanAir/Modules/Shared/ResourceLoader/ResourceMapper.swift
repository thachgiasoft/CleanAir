//
//  ResourceMapper.swift
//  CleanAir
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

final class ResourceMapper<T: Decodable, Z> {
  private struct Root<T: Decodable>: Decodable {
    let results: T
  }
  
  private let modelMapper: (T) -> Z
  private struct InvalidData: Error { }
  
  init(_ modelMapper: @escaping (T) -> Z) {
    self.modelMapper = modelMapper
  }
  
  func map(_ data: Data, from response: HTTPURLResponse) throws -> Z {
    guard response.statusCode == 200, let result = try? JSONDecoder().decode(Root<T>.self, from: data) else { throw InvalidData() }
    return modelMapper(result.results)
  }
}

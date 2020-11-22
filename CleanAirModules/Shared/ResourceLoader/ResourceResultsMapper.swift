//
//  ResourceResultsMapper.swift
//  CleanAir
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

public  final class ResourceResultsMapper<T: Decodable, Z> {
  private struct Results<T: Decodable>: Decodable {
    let results: T
  }
  
  private let modelMapper: (T) -> Z
  
  struct InvalidData: Error { }
  struct InvalidStatusCode: Error { }
  
  public init(_ modelMapper: @escaping (T) -> Z) {
    self.modelMapper = modelMapper
  }
  
  public func map(_ data: Data, from response: HTTPURLResponse) throws -> Z {
    guard response.statusCode == 200 else { throw InvalidStatusCode() }
    guard let result = try? JSONDecoder().decode(Results<T>.self, from: data) else { throw InvalidData() }
    return modelMapper(result.results)
  }
}

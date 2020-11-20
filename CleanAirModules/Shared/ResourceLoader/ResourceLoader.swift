//
//  ResourceLoader.swift
//  CleanAir
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

public class ResourceLoader<Resource> {
  let client: HTTPClient
  let url: URL
  let mapper: Mapper
  
  public typealias Mapper = (Data, HTTPURLResponse) throws -> Resource
  public typealias Result = Swift.Result<Resource, Error>
  
  public enum ResourceLoaderError: Swift.Error {
    case connectivity
  }
  
  public init(client: HTTPClient, url: URL, mapper: @escaping Mapper) {
    self.client = client
    self.url = url
    self.mapper = mapper
  }
  
  public func load(completion: @escaping (Result) -> Void) {
    client.execute(request: Self.getRequest(with: url)) { [weak self] response in
      guard let self = self else { return }
      switch response {
      case let .success((data, response)):
        do {
          completion(.success(try self.mapper(data, response)))
        } catch {
          completion(.failure(error))
        }
        
      case .failure:
        completion(.failure(ResourceLoaderError.connectivity))
      }
    }
  }
}

// MARK: - Private
private extension ResourceLoader {
  static func getRequest(with url: URL) -> URLRequest {
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    return request
  }
}

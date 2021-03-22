//
//  CountriesLoaderWithCaching.swift
//  CleanAirModules
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

public class CountriesLoaderWithCaching {
  let loader: CountriesLoader
  let cacheLoader: ResourceCacheLoader<[Country]>
  let cacheCacher: ResourceCacheCacher<[Country]>
  
  public init(loader: CountriesLoader,
              cacheLoader: ResourceCacheLoader<[Country]>,
              cacheCacher: ResourceCacheCacher<[Country]>) {
    self.loader = loader
    self.cacheLoader = cacheLoader
    self.cacheCacher = cacheCacher
  }
}

// MARK: - CountriesLoader
extension CountriesLoaderWithCaching: CountriesLoader {
  public func load(completion: @escaping (Result<[Country], Error>) -> Void) {
    switch cacheLoader.load() {
    case let .some(cache):
      completion(.success(cache))
      
    case .none:
      fetch(completion: completion)
    }
  }
}

// MARK: - Private
private extension CountriesLoaderWithCaching {
  func fetch(completion: @escaping (Result<[Country], Error>) -> Void) {
    loader.load { [weak self] result in
      if case let .success(countries) = result {
        try? self?.cacheCacher.cache(resource: countries)
      }
      completion(result)
    }
  }
}

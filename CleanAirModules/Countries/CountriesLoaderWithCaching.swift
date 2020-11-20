//
//  CountriesLoaderWithCaching.swift
//  CleanAirModules
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

public class CountriesLoaderWithCaching {
  let loader: CountriesLoader
  let cache: ResourceCacheLoader<[Country], CountriesStorage>
  
  public init(loader: CountriesLoader, cache: ResourceCacheLoader<[Country], CountriesStorage>) {
    self.loader = loader
    self.cache = cache
  }
}

// MARK: - CountriesLoader
extension CountriesLoaderWithCaching: CountriesLoader {
  public func load(completion: @escaping (Result<[Country], Error>) -> Void) {
    do {
      let cacheResult = try cache.load()
      completion(.success(cacheResult))
    } catch {
      fetch(completion: completion)
    }
  }
}

// MARK: - Private
private extension CountriesLoaderWithCaching {
  func fetch(completion: @escaping (Result<[Country], Error>) -> Void) {
    loader.load { [weak self] result in
      if case let .success(countries) = result {
        self?.cache.cache(resource: countries)
      }
      completion(result)
    }
  }
}

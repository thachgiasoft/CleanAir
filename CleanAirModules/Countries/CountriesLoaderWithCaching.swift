//
//  CountriesLoaderWithCaching.swift
//  CleanAirModules
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

public class CountriesLoaderWithCaching {
  let loader: CountriesLoader
  let cacher: ResourceCacher<[Country], CountriesStorage>
  
  public init(loader: CountriesLoader, cacher: ResourceCacher<[Country], CountriesStorage>) {
    self.loader = loader
    self.cacher = cacher
  }
}

// MARK: - CountriesLoader
extension CountriesLoaderWithCaching: CountriesLoader {
  public func load(completion: @escaping (Result<[Country], Error>) -> Void) {
    do {
      let cacheResult = try cacher.load()
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
        self?.cacher.cache(resource: countries)
      }
      completion(result)
    }
  }
}

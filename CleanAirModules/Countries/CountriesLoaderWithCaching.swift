//
//  CountriesLoaderWithCaching.swift
//  CleanAirModules
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

public class CountriesLoaderWithCaching {
  let loader: CountriesLoader
  let cache: ResourceCache<[Country], CountriesStorage>
  
  public init(loader: CountriesLoader, cache: ResourceCache<[Country], CountriesStorage>) {
    self.loader = loader
    self.cache = cache
  }
}

// MARK: - CountriesLoader
extension CountriesLoaderWithCaching: CountriesLoader {
  public func load(completion: @escaping (Result<[Country], Error>) -> Void) {
    loader.load { [weak self] result in
      if case let .success(countries) = result {
        self?.cache.cache(resource: countries)
      }
      completion(result)
    }
  }
}

//
//  CitiesLoaderWithLocalValidation.swift
//  CleanAirModules
//
//  Created by Marko Engelman on 21/11/2020.
//

import Foundation

public class CitiesLoaderWithLocalValidation {
  let loader: ResourceLoader<[City]>
  let storage: CityStorage
  
  public init(loader: ResourceLoader<[City]>, storage: CityStorage) {
    self.loader = loader
    self.storage = storage
  }
}

// MARK: - CitiesLoader
extension CitiesLoaderWithLocalValidation: CitiesLoader {
  public func load(completion: @escaping (Result<[City], Error>) -> Void) {
    
  }
}

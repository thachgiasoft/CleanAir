//
//  CitiesLoaderWithStorageValidation.swift
//  CleanAirModules
//
//  Created by Marko Engelman on 21/11/2020.
//

import Foundation

public class CitiesLoaderWithStorageValidation {
  let loader: CitiesLoader
  let storage: CityStorage
  
  public init(loader: CitiesLoader, storage: CityStorage) {
    self.loader = loader
    self.storage = storage
  }
}

// MARK: - CitiesLoader
extension CitiesLoaderWithStorageValidation: CitiesLoader {
  public func load(completion: @escaping (Result<[City], Error>) -> Void) {
    loader.load { [weak self] result in
      guard let self = self else { return }
      switch result {
      case let .success(cities):
        completion(.success(self.validate(cities)))
        
      case let .failure(error):
        completion(.failure(error))
      }
    }
  }
}

// MARK: - Private
private extension CitiesLoaderWithStorageValidation {
  func validate(_ cities: [City]) -> [City] {
    var validatedCities: [City] = []
    cities.forEach { city in
      if let localCity = storage.load(objectId: city.id) {
        let updatedCity = City(name: city.name, country: city.country, measurementsCount: city.measurementsCount, availableLocationsCount: city.availableLocationsCount, isFavourite: localCity.isFavourite)
        validatedCities.append(updatedCity)
      } else {
        validatedCities.append(city)
      }
    }
    return validatedCities
  }
}

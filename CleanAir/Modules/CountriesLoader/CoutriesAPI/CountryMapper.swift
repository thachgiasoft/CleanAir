//
//  CountryMapper.swift
//  CleanAir
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

final class CountryMapper {
  struct RemoteCountry: Decodable {
    let code: String
    let name: String?
    let count: Int
    let cities: Int
    let locations: Int
  }
  
  static func map(_ remoteModels: [RemoteCountry]) -> [Country] {
    return remoteModels.compactMap {
      guard let name = $0.name else { return nil }
      return Country(code: $0.code, name: name, totalNumberOfMeasurements: $0.count, numberOfMeasuredCities: $0.cities, numberOfMeasuringLocations: $0.locations)
    }
  }
}

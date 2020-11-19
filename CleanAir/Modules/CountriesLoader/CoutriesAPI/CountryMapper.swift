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
    let name: String
    let count: Int
    let cities: Int
    let locations: Int
  }
  
  func map(_ remoteModels: [RemoteCountry]) -> [Country] {
    return remoteModels.map { Country(name: $0.name, totalNumberOfMeasurements: $0.count, numberOfMeasuredCities: $0.cities, numberOfMeasuringLocations: $0.locations) }
  }
}

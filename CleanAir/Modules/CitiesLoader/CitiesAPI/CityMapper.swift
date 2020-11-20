//
//  CityMapper.swift
//  CleanAir
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

final class CityMapper {
  struct RemoteCity: Decodable {
    let name: String
    let country: String
    let count: Int
    let locations: Int
  }
  
  static func map(_ remoteModels: [RemoteCity]) -> [City] {
    return remoteModels.map { City(name: $0.name, country: $0.country, measurementsCount: $0.count, availableLocationsCount: $0.locations)}
  }
}

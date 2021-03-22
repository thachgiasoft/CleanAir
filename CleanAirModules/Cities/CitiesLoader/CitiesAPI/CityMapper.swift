//
//  CityMapper.swift
//  CleanAir
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

public struct RemoteCity: Decodable {
  let city: String
  let country: String
  let count: Int
  let locations: Int
}

public final class CityMapper {
  static let invalidNames = ["N/A", "unused"]
  
  public static func map(_ remoteModels: [RemoteCity]) -> [City] {
    return remoteModels.compactMap {
      guard !invalidNames.contains($0.city) else { return nil }
      return City(
        name: $0.city,
        country: $0.country,
        measurementsCount: $0.count,
        availableLocationsCount: $0.locations,
        isFavourite: false
      )
    }
  }
}

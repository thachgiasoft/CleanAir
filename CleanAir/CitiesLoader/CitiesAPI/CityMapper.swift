//
//  CityMapper.swift
//  CleanAir
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

final class CityMapper {
  private struct RemoteCity: Decodable {
    let name: String
    let country: String
    let count: Int
    let locations: Int
  }
  
  private struct InvalidData: Swift.Error { }
  
  func map(_ data: Data, from response: HTTPURLResponse) throws -> [City] {
    guard response.statusCode == 200, let result = try? JSONDecoder().decode([RemoteCity].self, from: data) else { throw InvalidData() }
    return result.map { City(name: $0.name, country: $0.country, measurementsCount: $0.count, availableLocationsCount: $0.locations)}
  }
}

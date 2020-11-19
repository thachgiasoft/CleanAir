//
//  CountryMapper.swift
//  CleanAir
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

final class CountryMapper {
  private struct RemoteCountry: Decodable {
    let code: String
    let name: String
    let count: Int
    let cities: Int
    let locations: Int
  }
  
  private struct InvalidData: Swift.Error { }
  
  func map(_ data: Data, from response: HTTPURLResponse) throws -> [Country] {
    guard response.statusCode == 200, let result = try? JSONDecoder().decode([RemoteCountry].self, from: data) else { throw InvalidData() }
    return result.map { Country(name: $0.name, totalNumberOfMeasurements: $0.count, numberOfMeasuredCities: $0.cities, numberOfMeasuringLocations: $0.locations) }
  }
}

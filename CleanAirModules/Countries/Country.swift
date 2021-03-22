//
//  Country.swift
//  CleanAir
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

public struct Country: Equatable {
  public let code: String
  public let name: String
  public let totalNumberOfMeasurements: Int
  public let numberOfMeasuredCities: Int
  public let numberOfMeasuringLocations: Int
  
  public init(code: String, name: String, totalNumberOfMeasurements: Int, numberOfMeasuredCities: Int, numberOfMeasuringLocations: Int) {
    self.code = code
    self.name = name
    self.totalNumberOfMeasurements = totalNumberOfMeasurements
    self.numberOfMeasuredCities = numberOfMeasuredCities
    self.numberOfMeasuringLocations = numberOfMeasuringLocations
  }
}

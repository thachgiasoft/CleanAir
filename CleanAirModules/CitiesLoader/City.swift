//
//  City.swift
//  CleanAir
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

public struct City {
  public  let name: String
  public let country: String
  public let measurementsCount: Int
  public let availableLocationsCount: Int
  
  public init(name: String, country: String, measurementsCount: Int, availableLocationsCount: Int) {
    self.name = name
    self.country = country
    self.measurementsCount = measurementsCount
    self.availableLocationsCount = availableLocationsCount
  }
}

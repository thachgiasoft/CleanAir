//
//  City.swift
//  CleanAir
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

public struct City: Equatable {
  public let id: String
  public let name: String
  public let country: String
  public let measurementsCount: Int
  public let availableLocationsCount: Int
  public private(set) var isFavourite: Bool
  
  public init(name: String, country: String, measurementsCount: Int, availableLocationsCount: Int, isFavourite: Bool) {
    self.id = name
    self.name = name
    self.country = country
    self.measurementsCount = measurementsCount
    self.availableLocationsCount = availableLocationsCount
    self.isFavourite = isFavourite
  }
  
  mutating public func makeFavourite() {
    self.isFavourite = true
  }
  
  mutating public func resetFavourite() {
    self.isFavourite = false
  }
}

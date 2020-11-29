//
//  CAMeasurement.swift
//  CleanAirModules
//
//  Created by Marko Engelman on 28/11/2020.
//

import Foundation

public struct CAMeasurement {
  public struct CAMeasurementData {
    public init(paramter: String, value: Double, unit: String) {
      self.paramter = paramter
      self.value = value
      self.unit = unit
    }
    
    public let paramter: String
    public let value: Double
    public let unit: String
  }
  
  public let timestamp: Date
  public let data: CAMeasurementData
  
  public init(timestamp: Date, data: CAMeasurement.CAMeasurementData) {
    self.timestamp = timestamp
    self.data = data
  }
}

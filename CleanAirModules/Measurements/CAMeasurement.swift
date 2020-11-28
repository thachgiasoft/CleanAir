//
//  CAMeasurement.swift
//  CleanAirModules
//
//  Created by Marko Engelman on 28/11/2020.
//

import Foundation

public struct CAMeasurement {
  public struct CAMeasurementData {
    public let paramter: String
    public let value: Double
    public let unit: String
  }
  
  public let timestamp: Date
  public let data: CAMeasurementData
}

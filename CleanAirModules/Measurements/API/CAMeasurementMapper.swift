//
//  CAMeasurementMapper.swift
//  CleanAirModules
//
//  Created by Marko Engelman on 29/11/2020.
//

import Foundation

public final class CAMeasurementsMapper {
  public struct RemoteMeasurement: Decodable {
    struct MeasurementDate: Decodable {
      let utc: Date
      let local: Date
    }
    
    let parameter: String
    let date: MeasurementDate
    let value: Double
    let unit: String
  }
  
  public static func map(_ remoteModels: [RemoteMeasurement]) -> [CAMeasurement] {
    return remoteModels.map {
      return CAMeasurement(
        timestamp: $0.date.utc,
        data: CAMeasurement.CAMeasurementData(
          paramter: $0.parameter,
          value: $0.value,
          unit: $0.unit
        )
      )
    }
  }
}

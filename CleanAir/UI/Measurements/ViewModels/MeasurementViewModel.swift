//
//  MeasurementViewModel.swift
//  CleanAir
//
//  Created by Marko Engelman on 21/03/2021.
//

import SwiftUI
import CleanAirModules

public class MeasurementViewModel: ObservableObject, Identifiable {
  private let caMeasurement: CAMeasurement

  public init(measurement: CAMeasurement) {
    self.caMeasurement = measurement
  }
  
  public var timeStamp: String {
    let formatter = DateFormatter()
    formatter.calendar = .current
    return formatter.string(from: caMeasurement.timestamp)
  }
  
  public var measurement: String {
    let data = caMeasurement.data
    return "\(data.paramter): \(data.value) \(data.unit)"
  }
}

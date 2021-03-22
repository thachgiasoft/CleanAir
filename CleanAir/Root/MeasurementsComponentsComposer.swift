//
//  MeasurementsComponentsComposer.swift
//  CleanAir
//
//  Created by Marko Engelman on 22/03/2021.
//

import Foundation
import CleanAirModules

final class MeasurementsComponentsComposer {
  static func measurementsLoader(client: HTTPClient, cityId: String) -> CAMeasurementsLoader {
    let loader = ResourceLoader(
      client: client,
      url: APIURL.measurements(for: cityId),
      mapper: ResourceResultsMapper(CAMeasurementsMapper.map).map
    )
    return loader
  }
}

//
//  CountriesCachePolicy.swift
//  CleanAirModules
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

public final class CountriesCachePolicy {
  public static func validate(cacheTimeStamp: TimeInterval) -> Bool {
    let now = Date().timeIntervalSince1970
    return now - cacheTimeStamp <= 60 * 60 * 24
  }
}

//
//  CountriesCachePolicy.swift
//  CleanAirModules
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

public final class CountriesCachePolicy {
  static let validCacheDuration: TimeInterval = 60 * 60 * 24
  
  public static func validate(cacheTimeStamp: Date, against: Date) -> Bool {
    return against.timeIntervalSince1970 - cacheTimeStamp.timeIntervalSince1970 <= validCacheDuration
  }
}

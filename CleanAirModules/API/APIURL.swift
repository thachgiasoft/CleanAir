//
//  APIURL.swift
//  CleanAir
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

public struct APIURL {
  private static let base = "https://api.openaq.org"
  private static let version = "v2"
  
  public static let countries = URL(string: "\(base)/\(version)/countries")!
  
  public static func cities(for country: String) -> URL {
    let countryQuery = country.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    return URL(string: "\(base)/\(version)/cities?country=\(countryQuery)")!
  }
  
  public static func cities() -> URL {
    return URL(string: "\(base)/\(version)/cities")!
  }
  
  public static func measurements(for city: String) -> URL {
    let cityQuery = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    return URL(string: "\(base)/\(version)/measurements?city=\(cityQuery)")!
  }
  
  public static func latestMeasurements() -> URL {
    return URL(string: "\(base)/\(version)/measurements")!
  }
}

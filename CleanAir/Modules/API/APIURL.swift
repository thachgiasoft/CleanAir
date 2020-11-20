//
//  APIURL.swift
//  CleanAir
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

struct APIURL {
  private static let base = "https://api.openaq.org"
  private static let version = "v1"
  static let countries = URL(string: "\(base)/\(version)/countries")!
  
  static func cities(for country: String) -> URL {
    return URL(string: "\(base)/\(version)/cities?country=\(country)")!
  }
}

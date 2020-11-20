//
//  LocalCountryCache.swift
//  CleanAirModules
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation
import RealmSwift

public class LocalCountryCache: Object {
  @objc dynamic var id: String = "1"
  @objc dynamic var timeStamp: Double = 0
  var countries = List<LocalCountry>()
  
  public override class func primaryKey() -> String? {
    return "id"
  }
}


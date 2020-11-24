//
//  RealmCountryCache.swift
//  CleanAirModules
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation
import RealmSwift

public class RealmCountryCache: Object {
  @objc dynamic var timeStamp: Int = 0
  var countries = List<LocalCountry>()
  
  public override class func primaryKey() -> String? {
    return "timeStamp"
  }
}


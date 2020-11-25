//
//  RealmCountryCache.swift
//  CleanAirModules
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation
import RealmSwift

public class RealmCountryCache: Object {
  @objc dynamic var id: Int = 0
  @objc dynamic var timestamp: Date = Date()
  var countries = List<RealmCountry>()
  
  public override class func primaryKey() -> String? {
    return "id"
  }
}


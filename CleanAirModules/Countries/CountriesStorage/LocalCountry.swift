//
//  RealmCountry.swift
//  CleanAirModules
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation
import RealmSwift

public class LocalCountry: Object {
  @objc dynamic var code: String = ""
  @objc dynamic var name: String? = nil
  @objc dynamic var count: Int = 0
  @objc dynamic var cities: Int = 0
  @objc dynamic var locations: Int = 0
  
  public override class func primaryKey() -> String? {
    return "code"
  }
}

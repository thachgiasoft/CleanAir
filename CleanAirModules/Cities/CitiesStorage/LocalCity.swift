//
//  LocalCity.swift
//  CleanAirModules
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation
import RealmSwift

public class LocalCity: Object {
  @objc dynamic var name: String = ""
  @objc dynamic var country: String = ""
  @objc dynamic var measurementsCount: Int = 0
  @objc dynamic var availableLocationsCount: Int = 0
  @objc dynamic var isFavourite: Bool = false
  
  public override class func primaryKey() -> String? {
    return "name"
  }
}

//
//  RealmStorageResultObserver.swift
//  CleanAirModules
//
//  Created by Marko Engelman on 26/11/2020.
//

import Foundation
import RealmSwift

class RealmStorageResultObserver<T> where T: Object {
  let result: Results<T>
  
  init(result: Results<T>) {
    self.result = result
  }
}

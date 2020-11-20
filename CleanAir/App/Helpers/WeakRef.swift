//
//  WeakRef.swift
//  CleanAir
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

final class WeakRef<T: AnyObject> {
  weak var object: T?
  
  init(_ object: T) {
    self.object = object
  }
}

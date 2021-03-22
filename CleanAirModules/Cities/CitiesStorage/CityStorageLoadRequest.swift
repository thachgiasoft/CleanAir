//
//  CityStorageLoadRequest.swift
//  CleanAirModules
//
//  Created by Marko Engelman on 26/11/2020.
//

import Foundation

public struct CityStorageLoadRequest {
  let isFavourite: Bool
  
  public init(isFavourite: Bool) {
    self.isFavourite = isFavourite
  }
}

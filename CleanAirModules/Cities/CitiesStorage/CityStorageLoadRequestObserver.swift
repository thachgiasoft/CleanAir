//
//  CityStorageLoadRequestObserver.swift
//  CleanAirModules
//
//  Created by Marko Engelman on 26/11/2020.
//

import Foundation

public protocol CityStorageLoadRequestObserver {
  var inserted: (((insertionIndexes: [Int], updatedLoadResult: [City])) -> Void)? { get set }
  var removed: (((removalIndexes: [Int], updatedLoadResult: [City])) -> Void)? { get set }
}

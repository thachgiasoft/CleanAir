//
//  ResourceCache.swift
//  CleanAirModules
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

public struct ResourceCache<Resource> {
  public let id: Int
  public let resource: Resource
}

// MARK: - Equatable
extension ResourceCache: Equatable {
  public static func == (lhs: ResourceCache<Resource>, rhs: ResourceCache<Resource>) -> Bool {
    return lhs.id == rhs.id
  }
}

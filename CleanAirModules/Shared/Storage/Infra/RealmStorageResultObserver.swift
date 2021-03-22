//
//  RealmStorageResultObserver.swift
//  CleanAirModules
//
//  Created by Marko Engelman on 26/11/2020.
//

import Foundation
import RealmSwift

public class RealmStorageResultObserver<T> where T: Object {
  private (set) var token: NotificationToken? = nil
  public var inserted: (((insertionIndexes: [Int], updatedLoadResult: [T])) -> Void)?
  public var removed: (((removalIndexes: [Int], updatedLoadResult: [T])) -> Void)?
  
  deinit {
    token?.invalidate()
  }
  
  public init(result: Results<T>) {
    token = result.observe { [weak self] change in
      switch change {
      case .initial:
        break
        
      case .update(let newCollection, let deletions, let insertions, _):
        if !insertions.isEmpty { self?.inserted?((insertions, Array(newCollection.map { $0 }))) }
        if !deletions.isEmpty { self?.removed?((deletions, Array(newCollection.map { $0 }))) }
        
      case .error:
        break
      }
    }
  }
}

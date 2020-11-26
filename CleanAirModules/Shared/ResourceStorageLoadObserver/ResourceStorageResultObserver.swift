//
//  ResourceStorageResultObserver.swift
//  CleanAirModules
//
//  Created by Marko Engelman on 26/11/2020.
//

import Foundation
import RealmSwift

public class ResourceStorageResultObserver<Resource, T> where T: Object {
  public typealias Mapper = (T) -> Resource
  let observer: RealmStorageResultObserver<T>
  let mapper: Mapper
  
  public var inserted: (((insertionIndexes: [Int], updatedLoadResult: [Resource])) -> Void)?
  public var removed: (((removalIndexes: [Int], updatedLoadResult: [Resource])) -> Void)?
  
  public init(observer: RealmStorageResultObserver<T>, mapper: @escaping Mapper) {
    self.observer = observer
    self.mapper = mapper
    self.configure()
  }
}

// MARK: - Private
private extension ResourceStorageResultObserver {
  func configure() {
    observer.inserted = { [weak self] in
      guard let self = self else { return }
      self.inserted?(($0.insertionIndexes, $0.updatedLoadResult.map { self.mapper($0)} ))
    }
    
    observer.removed = { [weak self] in
      guard let self = self else { return }
      self.removed?(($0.removalIndexes, $0.updatedLoadResult.map { self.mapper($0)} ))
    }
  }
}

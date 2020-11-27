//
//  FavouriteCitiesPresentationAdapter.swift
//  CleanAirPresentation
//
//  Created by Marko Engelman on 26/11/2020.
//

import Foundation
import CleanAirModules

public class FavouriteCitiesPresentationAdapter<FavouriteCitiesView> where FavouriteCitiesView: ResourceView {
  let storage: CityStorage
  var loadResultObserver: CityStorageLoadRequestObserver?
  
  public var presenter: ResourceLoadingPresenter<[City], FavouriteCitiesView>?
  
  public init(storage: CityStorage) {
    self.storage = storage
  }
  
  public func load() {
    let (cities, observer) = storage.load(with: CityStorageLoadRequest(isFavourite: true))
    configure(with: observer)
    presenter?.didFinishLoading(with: cities)
  }
}

// MARK: - Private
private extension FavouriteCitiesPresentationAdapter {
  func configure(with observer: CityStorageLoadRequestObserver) {
    loadResultObserver = observer
    loadResultObserver?.inserted = { [weak self] change in self?.update(with: change.updatedLoadResult) }
    loadResultObserver?.removed = { [weak self] change in self?.update(with: change.updatedLoadResult) }
  }
  
  func update(with cities: [City]) {
    presenter?.didFinishLoading(with: cities)
  }
}

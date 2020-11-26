//
//  FavouriteCitiesPresentationAdapter.swift
//  CleanAirPresentation
//
//  Created by Marko Engelman on 26/11/2020.
//

import Foundation
import CleanAirModules

public class FavouriteCitiesPresentationAdapter<CitiesView> where CitiesView: ResourceView {
  let storage: CityStorage
  public var presenter: ResourcePresenter<[City], CitiesView>?
  
  public init(storage: CityStorage) {
    self.storage = storage
  }
}

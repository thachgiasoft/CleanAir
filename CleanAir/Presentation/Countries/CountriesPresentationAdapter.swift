//
//  CountriesPresentationAdapter.swift
//  CleanAir
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

class CountriesPresentationAdapter {
  let loader: CountriesLoader
  var presenter: CountriesPresenter?
  
  init(loader: CountriesLoader) {
    self.loader = loader
  }
  
  func load() {
    presenter?.didStartLoading()
    loader.load { [weak self] result in
      DispatchQueue.main.async {
        switch result {
        case let .success(resource):
          self?.presenter?.didFinishLoading(with: resource)
          
        case let .failure(error):
          self?.presenter?.didFinishLoading(with: error)
        }
      }
    }
  }
}

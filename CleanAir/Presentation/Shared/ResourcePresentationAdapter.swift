//
//  ResourcePresentationAdapter.swift
//  CleanAir
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

class ResourcePresentationAdapter<Resource, View> where View: ResourceView {
  let loader: ResourceLoader<Resource>
  var presenter: ResourcePresenter<Resource, View>?
  
  init(loader: ResourceLoader<Resource>) {
    self.loader = loader
  }
  
  func load() where Resource == View.ResourceViewModel {
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

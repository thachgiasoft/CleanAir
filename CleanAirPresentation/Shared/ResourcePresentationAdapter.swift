//
//  ResourcePresentationAdapter.swift
//  CleanAir
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

public class ResourcePresentationAdapter<Resource, View> where View: ResourceView {
  public typealias Result = Swift.Result<Resource, Error>
  public typealias ResultCompletion = ((Result) -> Void)
  public typealias Loader = (_ completion: @escaping ResultCompletion) -> Void
  
  let loader: Loader
  public var presenter: ResourcePresenter<Resource, View>?
  
  public init(loader: @escaping Loader) {
    self.loader = loader
  }
  
  public func load() where Resource == View.ResourceViewModel {
    presenter?.didStartLoading()
    loader { [weak self] result in
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

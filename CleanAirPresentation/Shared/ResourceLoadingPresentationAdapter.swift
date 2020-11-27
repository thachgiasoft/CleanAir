//
//  ResourceLoadingPresentationAdapter.swift
//  CleanAir
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

public class ResourceLoadingPresentationAdapter<Resource, View> where View: ResourceView {
  public typealias Result = Swift.Result<Resource, Error>
  public typealias ResultCompletion = ((Result) -> Void)
  public typealias Loader = (_ completion: @escaping ResultCompletion) -> Void
  
  let loader: Loader
  let queue: DispatchQueue
  public var presenter: ResourceLoadingPresenter<Resource, View>?
  
  public init(loader: @escaping Loader, queue: DispatchQueue = .main) {
    self.loader = loader
    self.queue = queue
  }
  
  public func load() where Resource == View.ResourceViewModel {
    presenter?.didStartLoading()
    loader { [queue ,presenter] result in
      queue.async {
        switch result {
        case let .success(resource):
          presenter?.didFinishLoading(with: resource)
          
        case let .failure(error):
          presenter?.didFinishLoading(with: error)
        }
      }
    }
  }
}

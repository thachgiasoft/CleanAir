//
//  ResourceLoadingPresenter.swift
//  CleanAir
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

public class ResourceLoadingPresenter<Resource, View> where View: ResourceView {
  let view: View
  let loadingView: ResourceLoadingView
  let errorView: ResourceErrorView
  let viewModelMapper: (Resource) -> View.ResourceViewModel
  
  private var isLoading = false
  
  public init(view: View, loadingView: ResourceLoadingView, errorView: ResourceErrorView) where Resource == View.ResourceViewModel {
    self.view = view
    self.loadingView = loadingView
    self.errorView = errorView
    self.viewModelMapper = { $0 }
  }
  
  public init(view: View, loadingView: ResourceLoadingView, errorView: ResourceErrorView, viewModelMapper: @escaping (Resource) -> View.ResourceViewModel) {
    self.view = view
    self.loadingView = loadingView
    self.errorView = errorView
    self.viewModelMapper = viewModelMapper
  }
  
  public func didStartLoading() {
    isLoading = true
    loadingView.show(loadingViewModel: ResourceLoadingViewModel(isLoading: isLoading))
  }
  
  public func didFinishLoading(with resource: Resource) {
    isLoading = false
    loadingView.show(loadingViewModel: ResourceLoadingViewModel(isLoading: isLoading))
    view.show(resourceViewModel: viewModelMapper(resource))
  }
  
  public func didFinishLoading(with error: Error) {
    isLoading = false
    loadingView.show(loadingViewModel: ResourceLoadingViewModel(isLoading: isLoading))
    errorView.show(errorViewModel: ResourceErrorViewModel(error: error.localizedDescription))
  }
}

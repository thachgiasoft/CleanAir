//
//  ResourcePresenter.swift
//  CleanAir
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

class ResourcePresenter<Resource, View> where View: ResourceView {
  let view: View
  let loadingView: ResourceLoadingView
  let errorView: ResourceErrorView
  private var isLoading = false
  
  init(view: View, loadingView: ResourceLoadingView, errorView: ResourceErrorView) {
    self.view = view
    self.loadingView = loadingView
    self.errorView = errorView
  }
  
  func didStartLoading() {
    isLoading = true
    loadingView.show(loadingViewModel: ResourceLoadingViewModel(isLoading: isLoading))
  }
  
  func didFinishLoading(with resource: Resource) where View.ResourceViewModel == Resource {
    isLoading = false
    loadingView.show(loadingViewModel: ResourceLoadingViewModel(isLoading: isLoading))
    view.show(resourceViewModel: resource)
  }
  
  func didFinishLoading(with error: Error) {
    isLoading = false
    loadingView.show(loadingViewModel: ResourceLoadingViewModel(isLoading: isLoading))
    errorView.show(errorViewModel: ResourceErrorViewModel(error: error.localizedDescription))
  }
}

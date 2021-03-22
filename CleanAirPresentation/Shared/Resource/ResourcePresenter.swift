//
//  ResourcePresenter.swift
//  CleanAirPresentation
//
//  Created by Marko Engelman on 27/11/2020.
//

import Foundation

public class ResourcePresenter<Resource, View> where View: ResourceView {
  let view: View
  let errorView: ResourceErrorView
  let viewModelMapper: (Resource) -> View.ResourceViewModel

  public init(view: View, errorView: ResourceErrorView) where Resource == View.ResourceViewModel {
    self.view = view
    self.errorView = errorView
    self.viewModelMapper = { $0 }
  }
  
  public init(view: View, errorView: ResourceErrorView, viewModelMapper: @escaping (Resource) -> View.ResourceViewModel) {
    self.view = view
    self.errorView = errorView
    self.viewModelMapper = viewModelMapper
  }
  
  public func didReceiveRequesToShow(resource: Resource) {
    view.show(resourceViewModel: viewModelMapper(resource))
  }
  
  public func didReceiveRequesToShowResource(error: Error) {
    errorView.show(errorViewModel: ResourceErrorViewModel(error: error.localizedDescription))
  }
}

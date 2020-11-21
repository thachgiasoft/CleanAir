//
//  AnyResourceView.swift
//  CleanAirPresentationTests
//
//  Created by Marko Engelman on 21/11/2020.
//

import Foundation
import CleanAirPresentation

class AnyResourceView<T>: ResourceView, ResourceLoadingView, ResourceErrorView where T: Any {
  var receivedResourceViewModel: T?
  var receivedResourceLoadingViewModel: ResourceLoadingViewModel?
  var receivedResourceErrorViewModel: ResourceErrorViewModel?
  
  func show(resourceViewModel: T) {
    receivedResourceViewModel = resourceViewModel
    
  }
  func show(loadingViewModel: ResourceLoadingViewModel) {
    receivedResourceLoadingViewModel = loadingViewModel
  }
  
  func show(errorViewModel: ResourceErrorViewModel) {
    receivedResourceErrorViewModel = errorViewModel
  }
}

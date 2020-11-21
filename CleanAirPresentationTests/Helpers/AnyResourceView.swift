//
//  AnyResourceView.swift
//  CleanAirPresentationTests
//
//  Created by Marko Engelman on 21/11/2020.
//

import Foundation
import CleanAirPresentation

class AnyResourceView<T>: ResourceView, ResourceLoadingView, ResourceErrorView where T: Any {
  func show(resourceViewModel: T) { }
  func show(loadingViewModel: ResourceLoadingViewModel) { }
  func show(errorViewModel: ResourceErrorViewModel) { }
}

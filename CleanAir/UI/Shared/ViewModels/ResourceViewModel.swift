//
//  ResourceViewModel.swift
//  CleanAir
//
//  Created by Marko Engelman on 27/11/2020.
//

import Foundation
import CleanAirPresentation

class ResourceViewModel<Resource>: ObservableObject {
  @Published var resource: Resource
  @Published var error: String?
  
  init(resource: Resource) {
    self.resource = resource
  }
}

// MARK: - ResourceView
extension ResourceViewModel: ResourceView {
  func show(resourceViewModel: Resource) {
    self.resource = resourceViewModel
  }
}

// MARK: - ResourceErrorView
extension ResourceViewModel: ResourceErrorView {
  func show(errorViewModel: ResourceErrorViewModel) {
    error = errorViewModel.error
  }
}

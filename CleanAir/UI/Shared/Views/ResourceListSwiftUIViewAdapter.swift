//
//  ResourceListSwiftUIViewAdapter.swift
//  CleanAir
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

typealias ResourceListViewViewModel = ResourceListSwiftUIViewAdapter
class ResourceListSwiftUIViewAdapter<ResourceViewModel>: ObservableObject {
  let onAppear: () -> Void
  let selection: (ResourceViewModel) -> Void
  @Published var resource: [ResourceViewModel]
  @Published var isLoading: Bool = false
  @Published var error: String?
  
  init(onAppear: @escaping () -> Void, onSelect: @escaping (_ resource: ResourceViewModel) -> Void, resource: [ResourceViewModel]) {
    self.onAppear = onAppear
    self.resource = resource
    self.selection = onSelect
  }
}

// MARK: - ResourceView
extension ResourceListSwiftUIViewAdapter: ResourceView {
  func show(resourceViewModel: [ResourceViewModel]) {
    self.resource = resourceViewModel
  }
}

// MARK: - ResourceLoadingView
extension ResourceListSwiftUIViewAdapter: ResourceLoadingView {
  func show(loadingViewModel: ResourceLoadingViewModel) {
    self.isLoading = loadingViewModel.isLoading
  }
}

// MARK: - ResourceErrorView
extension ResourceListSwiftUIViewAdapter: ResourceErrorView {
  func show(errorViewModel: ResourceErrorViewModel) {
    error = errorViewModel.error
  }
}

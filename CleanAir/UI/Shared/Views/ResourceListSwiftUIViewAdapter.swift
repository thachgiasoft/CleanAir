//
//  ResourceListSwiftUIViewAdapter.swift
//  CleanAir
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation
import CleanAirPresentation

typealias ResourceListViewViewModel = ResourceListSwiftUIViewAdapter

class ResourceListSwiftUIViewAdapter<Resource, ResourceViewModel>: ObservableObject {
  typealias ViewModelMapper = (Resource) -> ResourceViewModel
  let onAppear: () -> Void
  let selection: (Resource) -> Void
  let mapper: ViewModelMapper
  
  @Published var resource: [ResourceViewModel]
  @Published var isLoading: Bool = false
  @Published var error: String?
  
  init(onAppear: @escaping () -> Void,
       onSelect: @escaping (_ resource: Resource) -> Void,
       resource: [ResourceViewModel]) where Resource == ResourceViewModel {
    self.onAppear = onAppear
    self.resource = resource
    self.selection = onSelect
    self.mapper = { $0 }
  }
  
  init(onAppear: @escaping () -> Void,
       onSelect: @escaping (_ resource: Resource) -> Void,
       mapper: @escaping ViewModelMapper,
       resource: [ResourceViewModel] = []) {
    self.onAppear = onAppear
    self.resource = resource
    self.selection = onSelect
    self.mapper = mapper
  }
}

// MARK: - ResourceView
extension ResourceListSwiftUIViewAdapter: ResourceView {
  func show(resourceViewModel: [Resource]) {
    self.resource = resourceViewModel.map { mapper($0) }
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

//
//  ResourceLoadingListViewModel.swift
//  CleanAir
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation
import CleanAirPresentation

class ResourceLoadingListViewModel<Resource, ResourceViewModel>: ObservableObject {
  typealias ViewModelMapper = (Resource) -> ResourceViewModel
  let onAppear: () -> Void
  let selection: (Resource) -> Void
  let mapper: ViewModelMapper
  
  @Published var resourceViewModels: [ResourceViewModel]
  @Published var isLoading: Bool = false
  @Published var error: String?
  
  init(onAppear: @escaping () -> Void,
       onSelect: @escaping (_ resource: Resource) -> Void,
       resource: [ResourceViewModel]) where Resource == ResourceViewModel {
    self.onAppear = onAppear
    self.resourceViewModels = resource
    self.selection = onSelect
    self.mapper = { $0 }
  }
  
  init(onAppear: @escaping () -> Void,
       onSelect: @escaping (_ resource: Resource) -> Void,
       mapper: @escaping ViewModelMapper,
       resource: [ResourceViewModel] = []) {
    self.onAppear = onAppear
    self.resourceViewModels = resource
    self.selection = onSelect
    self.mapper = mapper
  }
}

// MARK: - ResourceView
extension ResourceLoadingListViewModel: ResourceView {
  func show(resourceViewModel: [Resource]) {
    self.resourceViewModels = resourceViewModel.map { mapper($0) }
  }
}

// MARK: - ResourceLoadingView
extension ResourceLoadingListViewModel: ResourceLoadingView {
  func show(loadingViewModel: ResourceLoadingViewModel) {
    self.isLoading = loadingViewModel.isLoading
  }
}

// MARK: - ResourceErrorView
extension ResourceLoadingListViewModel: ResourceErrorView {
  func show(errorViewModel: ResourceErrorViewModel) {
    error = errorViewModel.error
  }
}

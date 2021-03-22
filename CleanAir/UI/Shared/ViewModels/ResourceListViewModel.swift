//
//  ResourceListViewModel.swift
//  CleanAir
//
//  Created by Marko Engelman on 22/03/2021.
//

import Foundation

class ResourceListViewModel<Resource, ResourceViewModel>: Identifiable {
  typealias ViewModelMapper = (_ resource: Resource) -> ResourceViewModel
  
  let resource: Resource
  let viewModelMapper: ViewModelMapper
  
  init(resource: Resource, viewModelMapper: @escaping ViewModelMapper) {
    self.resource = resource
    self.viewModelMapper = viewModelMapper
  }
  
  var resourceViewModel: ResourceViewModel {
    return viewModelMapper(resource)
  }
}

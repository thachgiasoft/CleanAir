//
//  ResourceListViewModel.swift
//  CleanAir
//
//  Created by Marko Engelman on 21/03/2021.
//

import SwiftUI

struct ResourceListSwiftUIView<ResourceViewModel, ResourceView>: ResourceSwiftUIView where ResourceView: ResourceSwiftUIView {
  var viewModel: ResourceViewModel
  let selector: () -> Void
  let builder: (ResourceViewModel) -> ResourceView
  
  init(viewModel: ResourceViewModel,
       builder: @escaping (ResourceViewModel) -> ResourceView,
       selector: @escaping () -> Void) {
    self.viewModel = viewModel
    self.builder = builder
    self.selector = selector
  }
  
  var body: some View {
    builder(viewModel)
      .onTapGesture { selector() }
  }
}

//
//  ResourceLoadingListSwiftUIView.swift
//  CleanAir
//
//  Created by Marko Engelman on 27/11/2020.
//

import SwiftUI

struct ResourceLoadingListSwiftUIView<Resource, ResourceViewModel, ResourceView>: View where ResourceViewModel: Identifiable, ResourceView: ResourceSwiftUIView {
  var onAppear: () -> Void
  var builder: (ResourceViewModel) -> ResourceView
  
  @ObservedObject var viewModel: ResourceLoadingListViewModel<Resource, ResourceViewModel>
  var body: some View {
    ScrollView(.vertical, showsIndicators: true, content: {
      let coloumns = [GridItem(.flexible(maximum: .infinity))]
      LazyVGrid(columns: coloumns, alignment: .leading) {
        ForEach(viewModel.resource) { resource in
          builder(resource)
        }
      }
    })
    .onAppear(perform: { onAppear() })
  }
}

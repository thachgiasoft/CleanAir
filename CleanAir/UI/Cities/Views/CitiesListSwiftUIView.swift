//
//  CitiesListSwiftUIView.swift
//  CleanAir
//
//  Created by Marko Engelman on 20/11/2020.
//

import SwiftUI

struct CitiesListSwiftUIView: View {
  var onAppear: () -> Void
  @ObservedObject var viewModel: CitiesListViewViewModel
  
  var body: some View {
    if let error = viewModel.error {
      Text(error)
    } else {
      List(viewModel.resource, id: \.self.name) { city in
        CityListSwiftUIView(viewModel: city)
      }.onAppear(perform: {
        onAppear()
      })
      .navigationBarTitle(Text(viewModel.isLoading ? "Loading cities" : "Cities"))
    }
  }
}

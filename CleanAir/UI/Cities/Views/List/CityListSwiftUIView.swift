//
//  CityListSwiftUIView.swift
//  CleanAir
//
//  Created by Marko Engelman on 20/11/2020.
//

import SwiftUI

struct CityListSwiftUIView: View {
  var onAppear: () -> Void
  @ObservedObject var viewModel: CityListViewModel
  
  var body: some View {
    if let error = viewModel.error {
      Text(error)
    } else {
      List(viewModel.resource, id: \.self.name) { city in
        CitySwiftUIView(viewModel: city)
      }.onAppear(perform: {
        onAppear()
      })
      .navigationBarTitle(Text(viewModel.isLoading ? "Loading cities" : "Cities"))
    }
  }
}

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
    NavigationView {
      if let error = viewModel.error {
        Text(error)
      } else {
        List(viewModel.resource, id: \.self.name) { city in
          VStack(alignment: .leading, spacing: 10, content: {
            HStack {
              Text(city.name)
                .font(.body)
              Spacer()
              Button(action: {
                
              }) {
                Image(systemName: city.isFavourite ? "star.fill" : "star")
              }
            }
          })
        }.onAppear(perform: {
          onAppear()
        })
        .navigationBarTitle(Text(viewModel.isLoading ? "Loading cities" : "Cities"))
      }
    }
  }
}

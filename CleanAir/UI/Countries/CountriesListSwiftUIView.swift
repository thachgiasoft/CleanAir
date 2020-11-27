//
//  CountriesListSwiftUIView.swift
//  CleanAir
//
//  Created by Marko Engelman on 20/11/2020.
//

import SwiftUI

struct CountriesListSwiftUIView: View {
  var onAppear: () -> Void
  @ObservedObject var viewModel: CountriesListViewViewModel
  
  var body: some View {
    if let error = viewModel.error {
      Text(error)
    } else {
      List(viewModel.resource, id: \.self.name) { country in
        VStack(alignment: .leading, spacing: 10, content: {
          Text(country.name)
            .font(.title)
          Text("Cities: \(country.numberOfMeasuredCities)")
            .font(.body)
          Text("Mesausrements: \(country.numberOfMeasuringLocations)")
            .font(.body)
        }).onTapGesture {
          viewModel.selection(country)
        }
      } .onAppear(perform: {
        onAppear()
      })
      .navigationBarTitle(Text(viewModel.isLoading ? "Loading countries" : "Countries"))
    }
  }
}

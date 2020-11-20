//
//  CountriesListSwiftUIView.swift
//  CleanAir
//
//  Created by Marko Engelman on 20/11/2020.
//

import SwiftUI
import CleanAirModules

struct CountriesListSwiftUIView: View {
  var onAppear: () -> Void
  @ObservedObject var viewModel: CountriesListViewViewModel
  
  var body: some View {
    NavigationView {
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
        }.onAppear(perform: {
          onAppear()
        })
        .navigationBarTitle(Text(viewModel.isLoading ? "Loading countries" : "Countries"))
      }
    }
  }
}

struct CountriesListSwiftUIView_Previews: PreviewProvider {
  static var previews: some View {
    let countries = [
      Country(
        code: "1",
        name: "Short name country",
        totalNumberOfMeasurements: 1,
        numberOfMeasuredCities: 1,
        numberOfMeasuringLocations: 1),
      Country(
        code: "2",
        name: "Country",
        totalNumberOfMeasurements: 1,
        numberOfMeasuredCities: 1,
        numberOfMeasuringLocations: 1),
      Country(
        code: "3",
        name: "Long long long name counrty",
        totalNumberOfMeasurements: 1,
        numberOfMeasuredCities: 1,
        numberOfMeasuringLocations: 1),
      Country(
        code: "4",
        name: "Short name country 2",
        totalNumberOfMeasurements: 1,
        numberOfMeasuredCities: 1,
        numberOfMeasuringLocations: 1),
      Country(
        code: "5",
        name: "Country 2",
        totalNumberOfMeasurements: 1,
        numberOfMeasuredCities: 1,
        numberOfMeasuringLocations: 1),
      Country(
        code: "6",
        name: "Long long long name counrty 2",
        totalNumberOfMeasurements: 1,
        numberOfMeasuredCities: 1,
        numberOfMeasuringLocations: 1)
    ]
    CountriesListSwiftUIView(
      onAppear: { },
      viewModel: CountriesListViewViewModel(
        onAppear: { }, onSelect: { _ in },
        resource: countries)
    )
  }
}

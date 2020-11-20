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
    NavigationView {
      if let error = viewModel.error {
        Text(error)
      } else {
        List(viewModel.countries, id: \.self.name) { country in
          VStack(alignment: .leading, spacing: 10, content: {
            Text(country.name)
              .font(.title)
            Text("Cities: \(country.numberOfMeasuredCities)")
              .font(.body)
            Text("Mesausrements: \(country.numberOfMeasuringLocations)")
              .font(.body)
          })
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
        name: "Short name country",
        totalNumberOfMeasurements: 1,
        numberOfMeasuredCities: 1,
        numberOfMeasuringLocations: 1),
      Country(
        name: "Country",
        totalNumberOfMeasurements: 1,
        numberOfMeasuredCities: 1,
        numberOfMeasuringLocations: 1),
      Country(
        name: "Long long long name counrty",
        totalNumberOfMeasurements: 1,
        numberOfMeasuredCities: 1,
        numberOfMeasuringLocations: 1),
      Country(
        name: "Short name country 2",
        totalNumberOfMeasurements: 1,
        numberOfMeasuredCities: 1,
        numberOfMeasuringLocations: 1),
      Country(
        name: "Country 2",
        totalNumberOfMeasurements: 1,
        numberOfMeasuredCities: 1,
        numberOfMeasuringLocations: 1),
      Country(
        name: "Long long long name counrty 2",
        totalNumberOfMeasurements: 1,
        numberOfMeasuredCities: 1,
        numberOfMeasuringLocations: 1)
    ]
    CountriesListSwiftUIView(
      onAppear: { },
      viewModel: CountriesListViewViewModel(onAppear: { }, countries: countries)
    )
  }
}

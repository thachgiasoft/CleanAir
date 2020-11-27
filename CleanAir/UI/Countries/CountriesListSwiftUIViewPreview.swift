//
//  CountriesListSwiftUIViewPreview.swift
//  CleanAir
//
//  Created by Marko Engelman on 20/11/2020.
//

import SwiftUI
import CleanAirModules

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

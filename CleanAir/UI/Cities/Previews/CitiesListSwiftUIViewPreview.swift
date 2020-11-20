//
//  CitiesListSwiftUIViewPreview.swift
//  CleanAir
//
//  Created by Marko Engelman on 20/11/2020.
//

import SwiftUI
import CleanAirModules

struct CitiesListSwiftUIView_Previews: PreviewProvider {
  static var previews: some View {
    let cities = [
      City(
        name: "Short name city",
        country: "country",
        measurementsCount: 1, availableLocationsCount: 1),
      City(
        name: "Name city",
        country: "country",
        measurementsCount: 1, availableLocationsCount: 1),
      City(
        name: "Long name city",
        country: "country",
        measurementsCount: 1, availableLocationsCount: 1),
      City(
        name: "Long long name city",
        country: "country",
        measurementsCount: 1, availableLocationsCount: 1)
    ]
    CitiesListSwiftUIView(
      onAppear: { },
      viewModel: ResourceListViewViewModel(
        onAppear: { },
        onSelect: { _ in },
        resource: cities)
    )
  }
}

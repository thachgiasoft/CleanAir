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
        measurementsCount: 1, availableLocationsCount: 1,
        isFavourite: true),
      City(
        name: "Name city",
        country: "country",
        measurementsCount: 1, availableLocationsCount: 1,
        isFavourite: false),
      City(
        name: "Long name city",
        country: "country",
        measurementsCount: 1, availableLocationsCount: 1,
        isFavourite: false),
      City(
        name: "Long long name city",
        country: "country",
        measurementsCount: 1, availableLocationsCount: 1,
        isFavourite: false)
    ]
    CityListSwiftUIView(
      onAppear: { },
      viewModel: ResourceListViewModel<City, CityViewModel>(
        onAppear: { },
        onSelect: { _ in },
        mapper: CityViewModelMapper.map,
        resource: CityViewModelMapper.map(models: cities))
    )
  }
}

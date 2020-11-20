//
//  CitiesListSwiftUIView.swift
//  CleanAir
//
//  Created by Marko Engelman on 20/11/2020.
//

import SwiftUI
import CleanAirModules

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
            Text(city.name)
              .font(.body)
          })
        }.onAppear(perform: {
          onAppear()
        })
        .navigationBarTitle(Text(viewModel.isLoading ? "Loading cities" : "Cities"))
      }
    }
  }
}

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

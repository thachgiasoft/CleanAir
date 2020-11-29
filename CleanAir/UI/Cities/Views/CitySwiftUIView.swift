//
//  CitySwiftUIView.swift
//  CleanAir
//
//  Created by Marko Engelman on 21/11/2020.
//

import SwiftUI

struct CitySwiftUIView: View, ResourceSwiftUIView {
  @ObservedObject var viewModel: CityViewModel
  
  var body: some View {
    VStack(alignment: .leading, spacing: 10, content: {
      HStack {
        Text(viewModel.name)
          .font(.body)
        Spacer()
        Button(action: {
          viewModel.toggleFavourite?()
        }) {
          Image(systemName: viewModel.isFavourite ? "star.fill" : "star")
        }
      }
    }).padding(.all)
  }
}

struct CitySwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
      CitySwiftUIView(
        viewModel: CityViewModel(
          name: "City name",
          country: "City country",
          measurementsCount: 1,
          availableLocationsCount: 12,
          isFavourite: true
        )
      )
      .previewLayout(.sizeThatFits)
    }
}

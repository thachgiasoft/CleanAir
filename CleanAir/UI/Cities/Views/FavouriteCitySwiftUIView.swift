//
//  FavouriteCitySwiftUIView.swift
//  CleanAir
//
//  Created by Marko Engelman on 27/11/2020.
//

import SwiftUI

struct FavouriteCitySwiftUIView: View, ResourceSwiftUIView {
  @ObservedObject var viewModel: CityViewModel
  
  var body: some View {
    HStack {
      VStack(alignment: .leading, spacing: 10) {
        Text(viewModel.name)
          .font(.title)
        Text(viewModel.country)
          .font(.body)
      }
      
      Spacer()
      
      VStack(alignment: .trailing) {
        Button(action: {
          viewModel.toggleFavourite?()
        }) {
          Image(systemName: viewModel.isFavourite ? "star.fill" : "star")
            .foregroundColor(.yellow)
        }
      }
    }.padding(.all)
  }
}

struct FavouriteCitySwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
      FavouriteCitySwiftUIView(
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

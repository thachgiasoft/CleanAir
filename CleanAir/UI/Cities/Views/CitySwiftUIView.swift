//
//  CitySwiftUIView.swift
//  CleanAir
//
//  Created by Marko Engelman on 27/11/2020.
//

import SwiftUI

struct CitySwiftUIView: View, ResourceSwiftUIView {
  @ObservedObject var viewModel: CityViewModel
  
  var body: some View {
    HStack {
      VStack(alignment: .leading, spacing: 5) {
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
    .previewLayout(.device)
  }
}

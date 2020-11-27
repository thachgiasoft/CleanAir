//
//  FavouriteCityListSwiftUIView.swift
//  CleanAir
//
//  Created by Marko Engelman on 27/11/2020.
//

import SwiftUI

struct FavouriteCityListSwiftUIView: View {
  var onAppear: () -> Void
  @ObservedObject var viewModel: FavouriteCityListViewModel
  
  var body: some View {
    Text("")
  }
}

struct FavouriteCityListSwiftUIView_Previews: PreviewProvider {
  static var previews: some View {
    FavouriteCityListSwiftUIView(
      onAppear: {  },
      viewModel: ResourceListViewModel(
        onAppear: {  }, onSelect: { _ in },
        mapper: CityViewModelMapper.map
      )
    )
  }
}

//
//  FavouriteCityListSwiftUIView.swift
//  CleanAir
//
//  Created by Marko Engelman on 27/11/2020.
//

import SwiftUI

struct FavouriteCityListSwiftUIView: View {
  var onAppear: () -> Void
  var onAdd: () -> Void
  @ObservedObject var viewModel: FavouriteCityListViewModel
  
  var body: some View {
    List(viewModel.resource, id: \.self.name) { city in
      FavouriteCitySwiftUIView(viewModel: city)
    }.onAppear(perform: {
      onAppear()
    })
    .navigationBarItems(
      trailing:
        Button(action: {
          onAdd()
        }) {
          Image(systemName: "plus")
        }
    )
  }
}

struct FavouriteCityListSwiftUIView_Previews: PreviewProvider {
  static var previews: some View {
    FavouriteCityListSwiftUIView(
      onAppear: {  },
      onAdd: { },
      viewModel: ResourceListViewModel(
        onAppear: {  }, onSelect: { _ in },
        mapper: CityViewModelMapper.map
      )
    )
  }
}

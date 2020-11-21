//
//  CitiesUIComposer.swift
//  CleanAir
//
//  Created by Marko Engelman on 20/11/2020.
//

import SwiftUI
import CleanAirModules
import CleanAirPresentation

final class CitiesUIComposer {
  static func makeView(with loader: CitiesLoader, service: FavouriteCityService, selection: @escaping (City) -> Void) -> UIViewController {
    let adapter = ResourcePresentationAdapter<[City], WeakRef<CitiesListViewViewModel>>(loader: loader.load)
    let viewModel = CitiesListViewViewModel(
      onAppear: adapter.load,
      onSelect: selection,
      mapper: { CitiesUIComposer.viewModel(for: $0, with: service) },
      resource: []
    )
    
    var view = CitiesListSwiftUIView(onAppear: { }, viewModel: viewModel)
    let presenter = ResourcePresenter<[City], WeakRef<CitiesListViewViewModel>>(
      view: WeakRef(viewModel),
      loadingView: WeakRef(viewModel),
      errorView: WeakRef(viewModel)
    )
    adapter.presenter = presenter
    view.onAppear = adapter.load
    let controller = UIHostingController(rootView: view)
    return controller
  }
}

// MARK: - Private
private extension CitiesUIComposer {
  static func viewModel(for city: City, with service: FavouriteCityService) -> CityViewModel {
    let viewModel = CityViewModelMapper.map(model: city)
    let adapter = CityPresentationAdapter<WeakRef<CityViewModel>>(city: city, service: service)
    adapter.presenter = ResourcePresenter(
      view: WeakRef(viewModel),
      loadingView: WeakRef(viewModel),
      errorView: WeakRef(viewModel),
      viewModelMapper: CityViewModelMapper.map
    )
    viewModel.togglFavourite = adapter.togglFavourite
    return viewModel
  }
}

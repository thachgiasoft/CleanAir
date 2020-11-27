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
    let adapter = ResourceLoadingPresentationAdapter<[City], WeakRef<CityListViewModel>>(loader: loader.load)
    let viewModel = CityListViewModel(
      onAppear: adapter.load,
      onSelect: selection,
      mapper: { CitiesUIComposer.viewModel(for: $0, with: service) },
      resource: []
    )
    
    let view = CityListSwiftUIView(onAppear: viewModel.onAppear, viewModel: viewModel)
    let presenter = ResourceLoadingPresenter<[City], WeakRef<CityListViewModel>>(
      view: WeakRef(viewModel),
      loadingView: WeakRef(viewModel),
      errorView: WeakRef(viewModel)
    )
    adapter.presenter = presenter
    let controller = UIHostingController(rootView: view)
    return controller
  }
  
  static func makeFavouritesView(with storage: CityStorage, service: FavouriteCityService, onAdd: @escaping () -> Void) -> UIViewController {
    let adapter = FavouriteCitiesPresentationAdapter<WeakRef<FavouriteCityListViewModel>>(storage: storage)
    
    let viewModel = ResourceListViewModel<City, CityViewModel>(
      onAppear: adapter.load,
      onSelect: { _ in },
      mapper: { CitiesUIComposer.viewModel(for: $0, with: service) },
      resource: []
    )
    
    let view = ResourceListSwiftUIView<City, CityViewModel, FavouriteCitySwiftUIView>(
      onAppear: viewModel.onAppear,
      builder: { FavouriteCitySwiftUIView(viewModel:$0) },
      viewModel: viewModel
    )
    
    let presenter = ResourcePresenter<[City], WeakRef<FavouriteCityListViewModel>>(
      view: WeakRef(viewModel),
      errorView: WeakRef(viewModel)
    )
    
    adapter.presenter = presenter
    let listView = ResourceAddListViewSwiftUIView<ResourceListSwiftUIView<City, CityViewModel, FavouriteCitySwiftUIView>>(
      title: "Favourite cities",
      onAddClick: onAdd,
      listView: { view }
    )
    
    let controller = UIHostingController(rootView: listView)
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
      errorView: WeakRef(viewModel),
      viewModelMapper: CityViewModelMapper.map
    )
    viewModel.toggleFavourite = adapter.toggleFavourite
    return viewModel
  }
}

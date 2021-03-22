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
  static func makeView(with loader: CitiesLoader, service: FavouriteCityService, onSelect: @escaping (City) -> Void) -> UIViewController {
    typealias CityListViewModel = ResourceLoadingListViewModel<City, ResourceListViewModel<City, CityViewModel>>
    typealias CityListView = WeakRef<CityListViewModel>
    typealias CityListAdapter = ResourceLoadingPresentationAdapter<[City], CityListView>
    
    let adapter = CityListAdapter(loader: loader.load)
    
    let viewModel = CityListViewModel(
      onAppear: adapter.load,
      onSelect: onSelect,
      mapper: { CitiesUIComposer.viewModel(for: $0, with: service) },
      resource: []
    )
    
    let view = ResourceLoadingListSwiftUIView(
      onAppear: viewModel.onAppear,
      builder: { resourceListViewModel in
        ResourceListSwiftUIView(
          viewModel: resourceListViewModel.resourceViewModel,
          builder: { CitySwiftUIView(viewModel: $0) },
          selector: { onSelect(resourceListViewModel.resource) })
      },
      viewModel: viewModel
    )
    
    let presenter = ResourceLoadingPresenter(
      view: WeakRef(viewModel),
      loadingView: WeakRef(viewModel),
      errorView: WeakRef(viewModel)
    )
    
    adapter.presenter = presenter
    let controller = UIHostingController(rootView: view)
    controller.title = "Cities"
    return controller
  }
  
  static func makeFavouritesView(
    with storage: CityStorage,
    service: FavouriteCityService,
    onSelect: @escaping (_ city: City) -> Void,
    onAdd: @escaping () -> Void) -> UIViewController {
    typealias CityListViewModel = ResourceLoadingListViewModel<City, ResourceListViewModel<City, CityViewModel>>
    typealias CityListView = WeakRef<CityListViewModel>
    typealias CityListAdapter = FavouriteCitiesPresentationAdapter<CityListView>
    
    let adapter = CityListAdapter(storage: storage)
    
    let viewModel = CityListViewModel(
      onAppear: adapter.load,
      onSelect: onSelect,
      mapper: { CitiesUIComposer.viewModel(for: $0, with: service) },
      resource: []
    )
    
    let view = ResourceLoadingListSwiftUIView(
      onAppear: viewModel.onAppear,
      builder: { resourceListViewModel in
        ResourceListSwiftUIView(
          viewModel: resourceListViewModel.resourceViewModel,
          builder: { CitySwiftUIView(viewModel: $0) },
          selector: { onSelect(resourceListViewModel.resource) })
      },
      viewModel: viewModel
    )
    
    let presenter = ResourcePresenter(
      view: WeakRef(viewModel),
      errorView: WeakRef(viewModel)
    )
    
    adapter.presenter = presenter
    let listView = ResourceAddListViewSwiftUIView(
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
  static func viewModel(for city: City, with service: FavouriteCityService) -> ResourceListViewModel<City, CityViewModel> {
    let viewModel = ResourceListViewModel(
      resource: city,
      viewModelMapper: { model -> CityViewModel in
        let viewModel = CityViewModelMapper.map(model: model)
        let adapter = CityPresentationAdapter<WeakRef<CityViewModel>>(city: model, service: service)
        adapter.presenter = ResourcePresenter(
          view: WeakRef(viewModel),
          errorView: WeakRef(viewModel),
          viewModelMapper: CityViewModelMapper.map
        )
        viewModel.toggleFavourite = adapter.toggleFavourite
        return viewModel
      }
    )
    return viewModel
  }
}

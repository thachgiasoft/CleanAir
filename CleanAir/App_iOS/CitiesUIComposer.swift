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
    typealias CityListViewModel = ResourceLoadingListViewModel<City, CityViewModel>
    typealias CityListView = WeakRef<CityListViewModel>
    typealias CityListAdapter = ResourceLoadingPresentationAdapter<[City], CityListView>
    
    let adapter = CityListAdapter(loader: loader.load)
    
    let viewModel = ResourceLoadingListViewModel(
      onAppear: adapter.load,
      onSelect: selection,
      mapper: { CitiesUIComposer.viewModel(for: $0, with: service) },
      resource: []
    )
    
    let view = ResourceLoadingListSwiftUIView(
      onAppear: viewModel.onAppear,
      builder: { CitySwiftUIView(viewModel:$0) },
      viewModel: viewModel
    )
    
    let presenter = ResourceLoadingPresenter(
      view: WeakRef(viewModel),
      loadingView: WeakRef(viewModel),
      errorView: WeakRef(viewModel)
    )
    
    adapter.presenter = presenter
    return UIHostingController(rootView: view)
  }
  
  static func makeFavouritesView(
    with storage: CityStorage,
    service: FavouriteCityService,
    onSelect: @escaping (_ city: City) -> Void,
    onAdd: @escaping () -> Void) -> UIViewController {
    typealias CityListViewModel = ResourceLoadingListViewModel<City, CityViewModel>
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
      builder: { FavouriteCitySwiftUIView(viewModel:$0) },
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
  
  static func makeMeasurementsView(with loader: CAMeasurementsLoader) -> UIViewController {
    typealias MeasurementsViewModel = ResourceLoadingListViewModel<CAMeasurement, MeasurementViewModel>
    typealias MeasurementsView = WeakRef<MeasurementsViewModel>
    typealias MeasurementsAdapter = ResourceLoadingPresentationAdapter<[CAMeasurement], MeasurementsView>
    
    let adapter = MeasurementsAdapter(loader: loader.load)
    
    let viewModel = MeasurementsViewModel(
      onAppear: adapter.load,
      onSelect: { _ in },
      mapper: { MeasurementViewModel(measurement: $0) },
      resource: []
    )

    let view = ResourceLoadingListSwiftUIView(
      onAppear: viewModel.onAppear,
      builder: { MeasurementSwiftUIView(viewModel: $0) },
      viewModel: viewModel
    )
    
    let presenter = ResourceLoadingPresenter(
      view: WeakRef(viewModel),
      loadingView: WeakRef(viewModel),
      errorView: WeakRef(viewModel)
    )
    adapter.presenter = presenter
    
    return UIHostingController(rootView: view)
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

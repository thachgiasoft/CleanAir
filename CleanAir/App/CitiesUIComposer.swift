//
//  CitiesUIComposer.swift
//  CleanAir
//
//  Created by Marko Engelman on 20/11/2020.
//

import SwiftUI
import CleanAirModules

final class CitiesUIComposer {
  static func makeView(with loader: CitiesLoader, selection: @escaping (City) -> Void) -> UIViewController {
    let adapter = ResourcePresentationAdapter<[City], WeakRef<CitiesListViewViewModel>>(loader: loader)
    let viewModel = ResourceListViewViewModel<City>(
      onAppear: adapter.load,
      onSelect: selection,
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

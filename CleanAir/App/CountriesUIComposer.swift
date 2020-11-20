//
//  CountriesUIComposer.swift
//  CleanAir
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation
import SwiftUI

final class CountriesUIComposer {
  static func makeView(with loader: CountriesLoader, selection: @escaping (Country) -> Void) -> UIViewController {
    let adapter = ResourcePresentationAdapter<[Country], WeakRef<CountriesListViewViewModel>>(loader: loader)
    let viewModel = ResourceListViewViewModel<Country>(
      onAppear: adapter.load,
      onSelect: selection,
      resource: []
    )
    
    var view = CountriesListSwiftUIView(onAppear: { }, viewModel: viewModel)
    let presenter = ResourcePresenter<[Country], WeakRef<CountriesListViewViewModel>>(
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

extension WeakRef: ResourceView where T: ResourceView {
  func show(resourceViewModel: T.ResourceViewModel) {
    object?.show(resourceViewModel: resourceViewModel)
  }
}

extension WeakRef: ResourceLoadingView where T: ResourceLoadingView {
  func show(loadingViewModel: ResourceLoadingViewModel) {
    object?.show(loadingViewModel: loadingViewModel)
  }
}

extension WeakRef: ResourceErrorView where T: ResourceErrorView {
  func show(errorViewModel: ResourceErrorViewModel) {
    object?.show(errorViewModel: errorViewModel)
  }
}


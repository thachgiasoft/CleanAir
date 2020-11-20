//
//  CountriesUIComposer.swift
//  CleanAir
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation
import SwiftUI

final class CountriesUIComposer {
  static func makeView(with loader: CountriesLoader) -> UIViewController {
    let adapter = CountriesPresentationAdapter(loader: loader)
    let viewModel = CountriesListViewViewModel(onAppear: adapter.load)
    var view = CountriesListSwiftUIView(onAppear: { }, viewModel: viewModel)
    let presenter = CountriesPresenter(
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

extension WeakRef: CountriesView where T: CountriesView {
  func show(countriesViewModel: CountriesViewModel) {
    object?.show(countriesViewModel: countriesViewModel)
  }
}

extension WeakRef: CountriesLoadingView where T: CountriesLoadingView {
  func show(loadingViewModel: CountriesLoadingViewModel) {
    object?.show(loadingViewModel: loadingViewModel)
  }
}

extension WeakRef: CountriesErrorView where T: CountriesErrorView {
  func show(errorViewModel: CountriesErrorViewModel) {
    object?.show(errorViewModel: errorViewModel)
  }
}


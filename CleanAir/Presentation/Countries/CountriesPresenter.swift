//
//  CountriesPresenter.swift
//  CleanAir
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

class CountriesPresenter {
  let view: CountriesView
  let loadingView: CountriesLoadingView
  let errorView: CountriesErrorView
  private var isLoading = false
  
  init(view: CountriesView, loadingView: CountriesLoadingView, errorView: CountriesErrorView) {
    self.view = view
    self.loadingView = loadingView
    self.errorView = errorView
  }
  
  func didStartLoading() {
    isLoading = true
    loadingView.show(loadingViewModel: CountriesLoadingViewModel(isLoading: isLoading))
  }
  
  func didFinishLoading(with countries: [Country]) {
    isLoading = false
    loadingView.show(loadingViewModel: CountriesLoadingViewModel(isLoading: isLoading))
    view.show(countriesViewModel: CountriesViewModel(countries: countries))
  }
  
  func didFinishLoading(with error: Error) {
    isLoading = false
    loadingView.show(loadingViewModel: CountriesLoadingViewModel(isLoading: isLoading))
    errorView.show(errorViewModel: CountriesErrorViewModel(error: error.localizedDescription))
  }
}

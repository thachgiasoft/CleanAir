//
//  CountriesListSwiftUIViewAdapter.swift
//  CleanAir
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation
import SwiftUI

typealias CountriesListViewViewModel = CountriesListSwiftUIViewAdapter
class CountriesListSwiftUIViewAdapter: ObservableObject {
  let onAppear: () -> Void
  @Published var countries: [Country]
  @Published var isLoading: Bool = false
  
  init(onAppear: @escaping () -> Void, countries: [Country] = []) {
    self.onAppear = onAppear
    self.countries = countries
  }
}

// MARK: - CountriesView
extension CountriesListSwiftUIViewAdapter: CountriesView {
  func show(countriesViewModel: CountriesViewModel) {
    self.countries = countriesViewModel.countries
  }
}

// MARK: - CountriesLoadingView
extension CountriesListSwiftUIViewAdapter: CountriesLoadingView {
  func show(loadingViewModel: CountriesLoadingViewModel) {
    self.isLoading = loadingViewModel.isLoading
  }
}

// MARK: - CountriesView
extension CountriesListSwiftUIViewAdapter: CountriesErrorView {
  func show(errorViewModel: CountriesErrorViewModel) {
    
  }
}

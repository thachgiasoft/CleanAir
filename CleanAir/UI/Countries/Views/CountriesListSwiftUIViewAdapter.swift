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
  @Published var error: String?
  
  init(onAppear: @escaping () -> Void, countries: [Country] = []) {
    self.onAppear = onAppear
    self.countries = countries
  }
}

// MARK: - ResourceView
extension CountriesListSwiftUIViewAdapter: ResourceView {
  func show(resourceViewModel: [Country]) {
    countries = resourceViewModel
  }
}

// MARK: - ResourceLoadingView
extension CountriesListSwiftUIViewAdapter: ResourceLoadingView {
  func show(loadingViewModel: ResourceLoadingViewModel) {
    self.isLoading = loadingViewModel.isLoading
  }
}

// MARK: - ResourceErrorView
extension CountriesListSwiftUIViewAdapter: ResourceErrorView {
  func show(errorViewModel: ResourceErrorViewModel) {
    error = errorViewModel.error
  }
}

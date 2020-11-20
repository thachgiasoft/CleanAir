//
//  CountriesLoadingView.swift
//  CleanAir
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

struct CountriesLoadingViewModel {
  let isLoading: Bool
}

protocol CountriesLoadingView {
  func show(loadingViewModel: CountriesLoadingViewModel)
}

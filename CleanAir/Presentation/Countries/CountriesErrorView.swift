//
//  CountriesErrorView.swift
//  CleanAir
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

struct CountriesErrorViewModel {
  let error: String
}

protocol CountriesErrorView {
  func show(errorViewModel: CountriesErrorViewModel)
}

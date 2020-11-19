//
//  CountriesView.swift
//  CleanAir
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

struct CountriesViewModel {
  let countries: [Country]
}

protocol CountriesView {
  func show(countriesViewModel: CountriesViewModel)
}

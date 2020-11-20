//
//  CountriesPresenter.swift
//  CleanAir
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation
import CleanAirModules

final class CountriesPresenter {
  static func viewModel(for countries: [Country]) -> [Country] {
    return countries.sorted { $0.name < $1.name }
  }
}

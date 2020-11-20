//
//  CountriesPresenter.swift
//  CleanAir
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation
import CleanAirModules

public final class CountriesPresenter {
  public static func viewModel(for countries: [Country]) -> [CountryViewModel] {
    return countries.sorted { $0.name < $1.name }
  }
}

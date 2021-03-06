//
//  CityViewModel.swift
//  CleanAir
//
//  Created by Marko Engelman on 21/11/2020.
//

import SwiftUI
import CleanAirPresentation

public class CityViewModel: ObservableObject, Identifiable {
  public let name: String
  public let country: String
  public let measurementsCount: Int
  public let availableLocationsCount: Int
  @Published var isFavourite: Bool
  
  var toggleFavourite: (() -> Void)?
  
  public init(name: String, country: String, measurementsCount: Int, availableLocationsCount: Int, isFavourite: Bool) {
    self.name = name
    self.country = country
    self.measurementsCount = measurementsCount
    self.availableLocationsCount = availableLocationsCount
    self.isFavourite = isFavourite
  }
}

// MARK: - ResourceView
extension CityViewModel: ResourceView {
  public func show(resourceViewModel: CityViewModel) {
    isFavourite = resourceViewModel.isFavourite
  }
}

// MARK: - ResourceErrorView
extension CityViewModel: ResourceErrorView {
  public func show(errorViewModel: ResourceErrorViewModel) {
    
  }
}

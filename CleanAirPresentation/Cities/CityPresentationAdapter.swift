//
//  CityPresentationAdapter.swift
//  CleanAirPresentation
//
//  Created by Marko Engelman on 21/11/2020.
//

import Foundation
import CleanAirModules

public class CityPresentationAdapter<CityView> where CityView: ResourceView {
  private(set) var city: City
  let service: FavouriteCityService
  
  public var presenter: ResourceLoadingPresenter<City, CityView>?
  
  public init(city: City, service: FavouriteCityService) {
    self.city = city
    self.service = service
  }
  
  public func toggleFavourite() {
    presenter?.didStartLoading()
    do {
      city = try service.toggl(for: city)
      presenter?.didFinishLoading(with: city)
    } catch {
      presenter?.didFinishLoading(with: error)
    }
  }
}

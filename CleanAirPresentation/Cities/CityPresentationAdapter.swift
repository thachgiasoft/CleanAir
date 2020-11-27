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
  
  public var presenter: ResourcePresenter<City, CityView>?
  
  public init(city: City, service: FavouriteCityService) {
    self.city = city
    self.service = service
  }
  
  public func toggleFavourite() {
    do {
      city = try service.toggl(for: city)
      presenter?.didReceiveRequesToShow(resource: city)
    } catch {
      presenter?.didReceiveRequesToShowResource(error: error)
    }
  }
}

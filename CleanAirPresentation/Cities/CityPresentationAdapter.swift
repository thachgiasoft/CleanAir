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
    presenter?.didStartLoading()
    service.toggl(for: city) { [weak self] result in
      DispatchQueue.main.async {
        switch result {
        case let .success(updatedCity):
          self?.city = updatedCity
          self?.presenter?.didFinishLoading(with: updatedCity)
          
        case let .failure(error):
          self?.presenter?.didFinishLoading(with: error)
        }
      }
    }
  }
}
